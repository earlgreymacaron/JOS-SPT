
vmm/guest/obj/net/testoutput:     file format elf64-x86-64


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
  80003c:	e8 59 05 00 00       	callq  80059a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  800053:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r;

    binaryname = "testoutput";
  800062:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800069:	00 00 00 
  80006c:	48 bb 00 4d 80 00 00 	movabs $0x804d00,%rbx
  800073:	00 00 00 
  800076:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  800079:	48 b8 dd 24 80 00 00 	movabs $0x8024dd,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80008c:	00 00 00 
  80008f:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  800091:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800098:	00 00 00 
  80009b:	8b 00                	mov    (%rax),%eax
  80009d:	85 c0                	test   %eax,%eax
  80009f:	79 2a                	jns    8000cb <umain+0x88>
        panic("error forking");
  8000a1:	48 ba 0b 4d 80 00 00 	movabs $0x804d0b,%rdx
  8000a8:	00 00 00 
  8000ab:	be 17 00 00 00       	mov    $0x17,%esi
  8000b0:	48 bf 19 4d 80 00 00 	movabs $0x804d19,%rdi
  8000b7:	00 00 00 
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	48 b9 40 06 80 00 00 	movabs $0x800640,%rcx
  8000c6:	00 00 00 
  8000c9:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8000cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000d2:	00 00 00 
  8000d5:	8b 00                	mov    (%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 16                	jne    8000f1 <umain+0xae>
        output(ns_envid);
  8000db:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	48 b8 83 04 80 00 00 	movabs $0x800483,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
        return;
  8000ec:	e9 50 01 00 00       	jmpq   800241 <umain+0x1fe>
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000f8:	e9 1b 01 00 00       	jmpq   800218 <umain+0x1d5>
        if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000fd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800104:	00 00 00 
  800107:	48 8b 00             	mov    (%rax),%rax
  80010a:	ba 07 00 00 00       	mov    $0x7,%edx
  80010f:	48 89 c6             	mov    %rax,%rsi
  800112:	bf 00 00 00 00       	mov    $0x0,%edi
  800117:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  80011e:	00 00 00 
  800121:	ff d0                	callq  *%rax
  800123:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800126:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80012a:	79 30                	jns    80015c <umain+0x119>
            panic("sys_page_alloc: %e", r);
  80012c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80012f:	89 c1                	mov    %eax,%ecx
  800131:	48 ba 2a 4d 80 00 00 	movabs $0x804d2a,%rdx
  800138:	00 00 00 
  80013b:	be 1f 00 00 00       	mov    $0x1f,%esi
  800140:	48 bf 19 4d 80 00 00 	movabs $0x804d19,%rdi
  800147:	00 00 00 
  80014a:	b8 00 00 00 00       	mov    $0x0,%eax
  80014f:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  800156:	00 00 00 
  800159:	41 ff d0             	callq  *%r8
        pkt->jp_len = snprintf(pkt->jp_data,
  80015c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800163:	00 00 00 
  800166:	48 8b 18             	mov    (%rax),%rbx
  800169:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800170:	00 00 00 
  800173:	48 8b 00             	mov    (%rax),%rax
  800176:	48 8d 78 04          	lea    0x4(%rax),%rdi
  80017a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017d:	89 c1                	mov    %eax,%ecx
  80017f:	48 ba 3d 4d 80 00 00 	movabs $0x804d3d,%rdx
  800186:	00 00 00 
  800189:	be fc 0f 00 00       	mov    $0xffc,%esi
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b8 e1 12 80 00 00 	movabs $0x8012e1,%r8
  80019a:	00 00 00 
  80019d:	41 ff d0             	callq  *%r8
  8001a0:	89 03                	mov    %eax,(%rbx)
                PGSIZE - sizeof(pkt->jp_len),
                "Packet %02d", i);
        cprintf("Transmitting packet %d\n", i);
  8001a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001a5:	89 c6                	mov    %eax,%esi
  8001a7:	48 bf 49 4d 80 00 00 	movabs $0x804d49,%rdi
  8001ae:	00 00 00 
  8001b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b6:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  8001bd:	00 00 00 
  8001c0:	ff d2                	callq  *%rdx
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001c2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 10             	mov    (%rax),%rdx
  8001cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8001d6:	00 00 00 
  8001d9:	8b 00                	mov    (%rax),%eax
  8001db:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001e0:	be 0b 00 00 00       	mov    $0xb,%esi
  8001e5:	89 c7                	mov    %eax,%edi
  8001e7:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
        sys_page_unmap(0, pkt);
  8001f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001fa:	00 00 00 
  8001fd:	48 8b 00             	mov    (%rax),%rax
  800200:	48 89 c6             	mov    %rax,%rsi
  800203:	bf 00 00 00 00       	mov    $0x0,%edi
  800208:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
    else if (output_envid == 0) {
        output(ns_envid);
        return;
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800214:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800218:	83 7d ec 09          	cmpl   $0x9,-0x14(%rbp)
  80021c:	0f 8e db fe ff ff    	jle    8000fd <umain+0xba>
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800222:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  800229:	eb 10                	jmp    80023b <umain+0x1f8>
        sys_yield();
  80022b:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800237:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80023b:	83 7d ec 13          	cmpl   $0x13,-0x14(%rbp)
  80023f:	7e ea                	jle    80022b <umain+0x1e8>
        sys_yield();
}
  800241:	48 83 c4 28          	add    $0x28,%rsp
  800245:	5b                   	pop    %rbx
  800246:	5d                   	pop    %rbp
  800247:	c3                   	retq   

0000000000800248 <timer>:

#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
  80024c:	53                   	push   %rbx
  80024d:	48 83 ec 28          	sub    $0x28,%rsp
  800251:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800254:	89 75 d8             	mov    %esi,-0x28(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800257:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
  800263:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800266:	01 d0                	add    %edx,%eax
  800268:	89 45 ec             	mov    %eax,-0x14(%rbp)

    binaryname = "ns_timer";
  80026b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800272:	00 00 00 
  800275:	48 bb 68 4d 80 00 00 	movabs $0x804d68,%rbx
  80027c:	00 00 00 
  80027f:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800282:	eb 0c                	jmp    800290 <timer+0x48>
            sys_yield();
  800284:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  80028b:	00 00 00 
  80028e:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800290:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  800297:	00 00 00 
  80029a:	ff d0                	callq  *%rax
  80029c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80029f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8002a5:	73 06                	jae    8002ad <timer+0x65>
  8002a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002ab:	79 d7                	jns    800284 <timer+0x3c>
            sys_yield();
        }
        if (r < 0)
  8002ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002b1:	79 30                	jns    8002e3 <timer+0x9b>
            panic("sys_time_msec: %e", r);
  8002b3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	48 ba 71 4d 80 00 00 	movabs $0x804d71,%rdx
  8002bf:	00 00 00 
  8002c2:	be 10 00 00 00       	mov    $0x10,%esi
  8002c7:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  8002ce:	00 00 00 
  8002d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d6:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  8002dd:	00 00 00 
  8002e0:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8002e3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8002e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f0:	be 0c 00 00 00       	mov    $0xc,%esi
  8002f5:	89 c7                	mov    %eax,%edi
  8002f7:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  800303:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800307:	ba 00 00 00 00       	mov    $0x0,%edx
  80030c:	be 00 00 00 00       	mov    $0x0,%esi
  800311:	48 89 c7             	mov    %rax,%rdi
  800314:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  80031b:	00 00 00 
  80031e:	ff d0                	callq  *%rax
  800320:	89 45 e4             	mov    %eax,-0x1c(%rbp)

            if (whom != ns_envid) {
  800323:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800326:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800329:	39 c2                	cmp    %eax,%edx
  80032b:	74 22                	je     80034f <timer+0x107>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  80032d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800330:	89 c6                	mov    %eax,%esi
  800332:	48 bf 90 4d 80 00 00 	movabs $0x804d90,%rdi
  800339:	00 00 00 
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  800348:	00 00 00 
  80034b:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  80034d:	eb b4                	jmp    800303 <timer+0xbb>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  80034f:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  800356:	00 00 00 
  800359:	ff d0                	callq  *%rax
  80035b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80035e:	01 d0                	add    %edx,%eax
  800360:	89 45 ec             	mov    %eax,-0x14(%rbp)
            break;
        }
    }
  800363:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800364:	e9 27 ff ff ff       	jmpq   800290 <timer+0x48>

0000000000800369 <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  800369:	55                   	push   %rbp
  80036a:	48 89 e5             	mov    %rsp,%rbp
  80036d:	53                   	push   %rbx
  80036e:	48 83 ec 28          	sub    $0x28,%rsp
  800372:	89 7d dc             	mov    %edi,-0x24(%rbp)
    binaryname = "ns_input";
  800375:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80037c:	00 00 00 
  80037f:	48 bb cb 4d 80 00 00 	movabs $0x804dcb,%rbx
  800386:	00 00 00 
  800389:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        int r;
        if ((r = sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_U|PTE_W)) < 0)
  80038c:	ba 07 00 00 00       	mov    $0x7,%edx
  800391:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  800398:	00 00 00 
  80039b:	bf 00 00 00 00       	mov    $0x0,%edi
  8003a0:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  8003a7:	00 00 00 
  8003aa:	ff d0                	callq  *%rax
  8003ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003b3:	79 30                	jns    8003e5 <input+0x7c>
            panic("sys_page_alloc: %e", r);
  8003b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003b8:	89 c1                	mov    %eax,%ecx
  8003ba:	48 ba d4 4d 80 00 00 	movabs $0x804dd4,%rdx
  8003c1:	00 00 00 
  8003c4:	be 0e 00 00 00       	mov    $0xe,%esi
  8003c9:	48 bf e7 4d 80 00 00 	movabs $0x804de7,%rdi
  8003d0:	00 00 00 
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  8003df:	00 00 00 
  8003e2:	41 ff d0             	callq  *%r8
        r = sys_net_receive(nsipcbuf.pkt.jp_data, 1518);
  8003e5:	be ee 05 00 00       	mov    $0x5ee,%esi
  8003ea:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8003f1:	00 00 00 
  8003f4:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	callq  *%rax
  800400:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (r == 0) {
  800403:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800407:	75 0e                	jne    800417 <input+0xae>
            sys_yield();
  800409:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  800410:	00 00 00 
  800413:	ff d0                	callq  *%rax
  800415:	eb 67                	jmp    80047e <input+0x115>
        } else if (r < 0) {
  800417:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80041b:	79 22                	jns    80043f <input+0xd6>
            cprintf("Failed to receive packet: %e\n", r);
  80041d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420:	89 c6                	mov    %eax,%esi
  800422:	48 bf f3 4d 80 00 00 	movabs $0x804df3,%rdi
  800429:	00 00 00 
  80042c:	b8 00 00 00 00       	mov    $0x0,%eax
  800431:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  800438:	00 00 00 
  80043b:	ff d2                	callq  *%rdx
  80043d:	eb 3f                	jmp    80047e <input+0x115>
        } else if (r > 0) {
  80043f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800443:	7e 39                	jle    80047e <input+0x115>
            nsipcbuf.pkt.jp_len = r;
  800445:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80044c:	00 00 00 
  80044f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800452:	89 10                	mov    %edx,(%rax)
            ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_U|PTE_P);
  800454:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800457:	b9 05 00 00 00       	mov    $0x5,%ecx
  80045c:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  800463:	00 00 00 
  800466:	be 0a 00 00 00       	mov    $0xa,%esi
  80046b:	89 c7                	mov    %eax,%edi
  80046d:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  800474:	00 00 00 
  800477:	ff d0                	callq  *%rax
        }
    }
  800479:	e9 0e ff ff ff       	jmpq   80038c <input+0x23>
  80047e:	e9 09 ff ff ff       	jmpq   80038c <input+0x23>

0000000000800483 <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  800483:	55                   	push   %rbp
  800484:	48 89 e5             	mov    %rsp,%rbp
  800487:	53                   	push   %rbx
  800488:	48 83 ec 28          	sub    $0x28,%rsp
  80048c:	89 7d dc             	mov    %edi,-0x24(%rbp)
    binaryname = "ns_output";
  80048f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800496:	00 00 00 
  800499:	48 bb 18 4e 80 00 00 	movabs $0x804e18,%rbx
  8004a0:	00 00 00 
  8004a3:	48 89 18             	mov    %rbx,(%rax)

    int r;

    while (1) {
        int32_t req, whom;
        req = ipc_recv(&whom, &nsipcbuf, NULL);
  8004a6:	48 8d 45 e4          	lea    -0x1c(%rbp),%rax
  8004aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8004af:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8004b6:	00 00 00 
  8004b9:	48 89 c7             	mov    %rax,%rdi
  8004bc:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  8004c3:	00 00 00 
  8004c6:	ff d0                	callq  *%rax
  8004c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
        assert(whom == ns_envid);
  8004cb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004ce:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8004d1:	74 35                	je     800508 <output+0x85>
  8004d3:	48 b9 22 4e 80 00 00 	movabs $0x804e22,%rcx
  8004da:	00 00 00 
  8004dd:	48 ba 33 4e 80 00 00 	movabs $0x804e33,%rdx
  8004e4:	00 00 00 
  8004e7:	be 11 00 00 00       	mov    $0x11,%esi
  8004ec:	48 bf 48 4e 80 00 00 	movabs $0x804e48,%rdi
  8004f3:	00 00 00 
  8004f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fb:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  800502:	00 00 00 
  800505:	41 ff d0             	callq  *%r8
        assert(req == NSREQ_OUTPUT);
  800508:	83 7d ec 0b          	cmpl   $0xb,-0x14(%rbp)
  80050c:	74 35                	je     800543 <output+0xc0>
  80050e:	48 b9 55 4e 80 00 00 	movabs $0x804e55,%rcx
  800515:	00 00 00 
  800518:	48 ba 33 4e 80 00 00 	movabs $0x804e33,%rdx
  80051f:	00 00 00 
  800522:	be 12 00 00 00       	mov    $0x12,%esi
  800527:	48 bf 48 4e 80 00 00 	movabs $0x804e48,%rdi
  80052e:	00 00 00 
  800531:	b8 00 00 00 00       	mov    $0x0,%eax
  800536:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  80053d:	00 00 00 
  800540:	41 ff d0             	callq  *%r8
        if ((r = sys_net_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0)
  800543:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80054a:	00 00 00 
  80054d:	8b 00                	mov    (%rax),%eax
  80054f:	89 c6                	mov    %eax,%esi
  800551:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  800558:	00 00 00 
  80055b:	48 b8 08 20 80 00 00 	movabs $0x802008,%rax
  800562:	00 00 00 
  800565:	ff d0                	callq  *%rax
  800567:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80056a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80056e:	79 25                	jns    800595 <output+0x112>
            cprintf("Failed to transmit packet: %e\n", r);
  800570:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800573:	89 c6                	mov    %eax,%esi
  800575:	48 bf 70 4e 80 00 00 	movabs $0x804e70,%rdi
  80057c:	00 00 00 
  80057f:	b8 00 00 00 00       	mov    $0x0,%eax
  800584:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  80058b:	00 00 00 
  80058e:	ff d2                	callq  *%rdx
    }
  800590:	e9 11 ff ff ff       	jmpq   8004a6 <output+0x23>
  800595:	e9 0c ff ff ff       	jmpq   8004a6 <output+0x23>

000000000080059a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80059a:	55                   	push   %rbp
  80059b:	48 89 e5             	mov    %rsp,%rbp
  80059e:	48 83 ec 10          	sub    $0x10,%rsp
  8005a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8005a9:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  8005b0:	00 00 00 
  8005b3:	ff d0                	callq  *%rax
  8005b5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005ba:	48 98                	cltq   
  8005bc:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8005c3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8005ca:	00 00 00 
  8005cd:	48 01 c2             	add    %rax,%rdx
  8005d0:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8005d7:	00 00 00 
  8005da:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e1:	7e 14                	jle    8005f7 <libmain+0x5d>
		binaryname = argv[0];
  8005e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e7:	48 8b 10             	mov    (%rax),%rdx
  8005ea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8005f1:	00 00 00 
  8005f4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005fe:	48 89 d6             	mov    %rdx,%rsi
  800601:	89 c7                	mov    %eax,%edi
  800603:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80060f:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
}
  80061b:	c9                   	leaveq 
  80061c:	c3                   	retq   

000000000080061d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800621:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  800628:	00 00 00 
  80062b:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80062d:	bf 00 00 00 00       	mov    $0x0,%edi
  800632:	48 b8 9d 1c 80 00 00 	movabs $0x801c9d,%rax
  800639:	00 00 00 
  80063c:	ff d0                	callq  *%rax
}
  80063e:	5d                   	pop    %rbp
  80063f:	c3                   	retq   

0000000000800640 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800640:	55                   	push   %rbp
  800641:	48 89 e5             	mov    %rsp,%rbp
  800644:	53                   	push   %rbx
  800645:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80064c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800653:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800659:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800660:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800667:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80066e:	84 c0                	test   %al,%al
  800670:	74 23                	je     800695 <_panic+0x55>
  800672:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800679:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80067d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800681:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800685:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800689:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80068d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800691:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800695:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80069c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8006a3:	00 00 00 
  8006a6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8006ad:	00 00 00 
  8006b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8006bb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8006c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006c9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8006d0:	00 00 00 
  8006d3:	48 8b 18             	mov    (%rax),%rbx
  8006d6:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  8006dd:	00 00 00 
  8006e0:	ff d0                	callq  *%rax
  8006e2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8006e8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8006ef:	41 89 c8             	mov    %ecx,%r8d
  8006f2:	48 89 d1             	mov    %rdx,%rcx
  8006f5:	48 89 da             	mov    %rbx,%rdx
  8006f8:	89 c6                	mov    %eax,%esi
  8006fa:	48 bf a0 4e 80 00 00 	movabs $0x804ea0,%rdi
  800701:	00 00 00 
  800704:	b8 00 00 00 00       	mov    $0x0,%eax
  800709:	49 b9 79 08 80 00 00 	movabs $0x800879,%r9
  800710:	00 00 00 
  800713:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800716:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80071d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800724:	48 89 d6             	mov    %rdx,%rsi
  800727:	48 89 c7             	mov    %rax,%rdi
  80072a:	48 b8 cd 07 80 00 00 	movabs $0x8007cd,%rax
  800731:	00 00 00 
  800734:	ff d0                	callq  *%rax
	cprintf("\n");
  800736:	48 bf c3 4e 80 00 00 	movabs $0x804ec3,%rdi
  80073d:	00 00 00 
  800740:	b8 00 00 00 00       	mov    $0x0,%eax
  800745:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  80074c:	00 00 00 
  80074f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800751:	cc                   	int3   
  800752:	eb fd                	jmp    800751 <_panic+0x111>

0000000000800754 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800754:	55                   	push   %rbp
  800755:	48 89 e5             	mov    %rsp,%rbp
  800758:	48 83 ec 10          	sub    $0x10,%rsp
  80075c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80075f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800767:	8b 00                	mov    (%rax),%eax
  800769:	8d 48 01             	lea    0x1(%rax),%ecx
  80076c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800770:	89 0a                	mov    %ecx,(%rdx)
  800772:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800775:	89 d1                	mov    %edx,%ecx
  800777:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80077b:	48 98                	cltq   
  80077d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800781:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800785:	8b 00                	mov    (%rax),%eax
  800787:	3d ff 00 00 00       	cmp    $0xff,%eax
  80078c:	75 2c                	jne    8007ba <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80078e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800792:	8b 00                	mov    (%rax),%eax
  800794:	48 98                	cltq   
  800796:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80079a:	48 83 c2 08          	add    $0x8,%rdx
  80079e:	48 89 c6             	mov    %rax,%rsi
  8007a1:	48 89 d7             	mov    %rdx,%rdi
  8007a4:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  8007ab:	00 00 00 
  8007ae:	ff d0                	callq  *%rax
        b->idx = 0;
  8007b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007b4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8007ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007be:	8b 40 04             	mov    0x4(%rax),%eax
  8007c1:	8d 50 01             	lea    0x1(%rax),%edx
  8007c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007c8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8007cb:	c9                   	leaveq 
  8007cc:	c3                   	retq   

00000000008007cd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8007cd:	55                   	push   %rbp
  8007ce:	48 89 e5             	mov    %rsp,%rbp
  8007d1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8007d8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8007df:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8007e6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8007ed:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007f4:	48 8b 0a             	mov    (%rdx),%rcx
  8007f7:	48 89 08             	mov    %rcx,(%rax)
  8007fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800802:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800806:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80080a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800811:	00 00 00 
    b.cnt = 0;
  800814:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80081b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80081e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800825:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80082c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800833:	48 89 c6             	mov    %rax,%rsi
  800836:	48 bf 54 07 80 00 00 	movabs $0x800754,%rdi
  80083d:	00 00 00 
  800840:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  800847:	00 00 00 
  80084a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80084c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800852:	48 98                	cltq   
  800854:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80085b:	48 83 c2 08          	add    $0x8,%rdx
  80085f:	48 89 c6             	mov    %rax,%rsi
  800862:	48 89 d7             	mov    %rdx,%rdi
  800865:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  80086c:	00 00 00 
  80086f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800871:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800877:	c9                   	leaveq 
  800878:	c3                   	retq   

0000000000800879 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800879:	55                   	push   %rbp
  80087a:	48 89 e5             	mov    %rsp,%rbp
  80087d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800884:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80088b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800892:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800899:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8008a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8008a7:	84 c0                	test   %al,%al
  8008a9:	74 20                	je     8008cb <cprintf+0x52>
  8008ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8008af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8008b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8008b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8008bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8008bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8008c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8008c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8008cb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8008d2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8008d9:	00 00 00 
  8008dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8008e3:	00 00 00 
  8008e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8008ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8008f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8008ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800906:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80090d:	48 8b 0a             	mov    (%rdx),%rcx
  800910:	48 89 08             	mov    %rcx,(%rax)
  800913:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800917:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80091b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80091f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800923:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80092a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800931:	48 89 d6             	mov    %rdx,%rsi
  800934:	48 89 c7             	mov    %rax,%rdi
  800937:	48 b8 cd 07 80 00 00 	movabs $0x8007cd,%rax
  80093e:	00 00 00 
  800941:	ff d0                	callq  *%rax
  800943:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800949:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80094f:	c9                   	leaveq 
  800950:	c3                   	retq   

0000000000800951 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800951:	55                   	push   %rbp
  800952:	48 89 e5             	mov    %rsp,%rbp
  800955:	53                   	push   %rbx
  800956:	48 83 ec 38          	sub    $0x38,%rsp
  80095a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80095e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800962:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800966:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800969:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80096d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800971:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800974:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800978:	77 3b                	ja     8009b5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80097a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80097d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800981:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800984:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
  80098d:	48 f7 f3             	div    %rbx
  800990:	48 89 c2             	mov    %rax,%rdx
  800993:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800996:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800999:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	41 89 f9             	mov    %edi,%r9d
  8009a4:	48 89 c7             	mov    %rax,%rdi
  8009a7:	48 b8 51 09 80 00 00 	movabs $0x800951,%rax
  8009ae:	00 00 00 
  8009b1:	ff d0                	callq  *%rax
  8009b3:	eb 1e                	jmp    8009d3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009b5:	eb 12                	jmp    8009c9 <printnum+0x78>
			putch(padc, putdat);
  8009b7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8009bb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	48 89 ce             	mov    %rcx,%rsi
  8009c5:	89 d7                	mov    %edx,%edi
  8009c7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009c9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8009cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8009d1:	7f e4                	jg     8009b7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009d3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8009d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	48 f7 f1             	div    %rcx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 ba d0 50 80 00 00 	movabs $0x8050d0,%rdx
  8009ec:	00 00 00 
  8009ef:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009f3:	0f be d0             	movsbl %al,%edx
  8009f6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8009fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fe:	48 89 ce             	mov    %rcx,%rsi
  800a01:	89 d7                	mov    %edx,%edi
  800a03:	ff d0                	callq  *%rax
}
  800a05:	48 83 c4 38          	add    $0x38,%rsp
  800a09:	5b                   	pop    %rbx
  800a0a:	5d                   	pop    %rbp
  800a0b:	c3                   	retq   

0000000000800a0c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a0c:	55                   	push   %rbp
  800a0d:	48 89 e5             	mov    %rsp,%rbp
  800a10:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a18:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800a1b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a1f:	7e 52                	jle    800a73 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800a21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a25:	8b 00                	mov    (%rax),%eax
  800a27:	83 f8 30             	cmp    $0x30,%eax
  800a2a:	73 24                	jae    800a50 <getuint+0x44>
  800a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a30:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	8b 00                	mov    (%rax),%eax
  800a3a:	89 c0                	mov    %eax,%eax
  800a3c:	48 01 d0             	add    %rdx,%rax
  800a3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a43:	8b 12                	mov    (%rdx),%edx
  800a45:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4c:	89 0a                	mov    %ecx,(%rdx)
  800a4e:	eb 17                	jmp    800a67 <getuint+0x5b>
  800a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a54:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a58:	48 89 d0             	mov    %rdx,%rax
  800a5b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a63:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a67:	48 8b 00             	mov    (%rax),%rax
  800a6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a6e:	e9 a3 00 00 00       	jmpq   800b16 <getuint+0x10a>
	else if (lflag)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a77:	74 4f                	je     800ac8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7d:	8b 00                	mov    (%rax),%eax
  800a7f:	83 f8 30             	cmp    $0x30,%eax
  800a82:	73 24                	jae    800aa8 <getuint+0x9c>
  800a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a88:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a90:	8b 00                	mov    (%rax),%eax
  800a92:	89 c0                	mov    %eax,%eax
  800a94:	48 01 d0             	add    %rdx,%rax
  800a97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9b:	8b 12                	mov    (%rdx),%edx
  800a9d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa4:	89 0a                	mov    %ecx,(%rdx)
  800aa6:	eb 17                	jmp    800abf <getuint+0xb3>
  800aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ab0:	48 89 d0             	mov    %rdx,%rax
  800ab3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800abf:	48 8b 00             	mov    (%rax),%rax
  800ac2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ac6:	eb 4e                	jmp    800b16 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acc:	8b 00                	mov    (%rax),%eax
  800ace:	83 f8 30             	cmp    $0x30,%eax
  800ad1:	73 24                	jae    800af7 <getuint+0xeb>
  800ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	8b 00                	mov    (%rax),%eax
  800ae1:	89 c0                	mov    %eax,%eax
  800ae3:	48 01 d0             	add    %rdx,%rax
  800ae6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aea:	8b 12                	mov    (%rdx),%edx
  800aec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af3:	89 0a                	mov    %ecx,(%rdx)
  800af5:	eb 17                	jmp    800b0e <getuint+0x102>
  800af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aff:	48 89 d0             	mov    %rdx,%rax
  800b02:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b0e:	8b 00                	mov    (%rax),%eax
  800b10:	89 c0                	mov    %eax,%eax
  800b12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b1a:	c9                   	leaveq 
  800b1b:	c3                   	retq   

0000000000800b1c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b1c:	55                   	push   %rbp
  800b1d:	48 89 e5             	mov    %rsp,%rbp
  800b20:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b28:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800b2b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b2f:	7e 52                	jle    800b83 <getint+0x67>
		x=va_arg(*ap, long long);
  800b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b35:	8b 00                	mov    (%rax),%eax
  800b37:	83 f8 30             	cmp    $0x30,%eax
  800b3a:	73 24                	jae    800b60 <getint+0x44>
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b48:	8b 00                	mov    (%rax),%eax
  800b4a:	89 c0                	mov    %eax,%eax
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b53:	8b 12                	mov    (%rdx),%edx
  800b55:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5c:	89 0a                	mov    %ecx,(%rdx)
  800b5e:	eb 17                	jmp    800b77 <getint+0x5b>
  800b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b64:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b68:	48 89 d0             	mov    %rdx,%rax
  800b6b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b73:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b77:	48 8b 00             	mov    (%rax),%rax
  800b7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b7e:	e9 a3 00 00 00       	jmpq   800c26 <getint+0x10a>
	else if (lflag)
  800b83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b87:	74 4f                	je     800bd8 <getint+0xbc>
		x=va_arg(*ap, long);
  800b89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8d:	8b 00                	mov    (%rax),%eax
  800b8f:	83 f8 30             	cmp    $0x30,%eax
  800b92:	73 24                	jae    800bb8 <getint+0x9c>
  800b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b98:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba0:	8b 00                	mov    (%rax),%eax
  800ba2:	89 c0                	mov    %eax,%eax
  800ba4:	48 01 d0             	add    %rdx,%rax
  800ba7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bab:	8b 12                	mov    (%rdx),%edx
  800bad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb4:	89 0a                	mov    %ecx,(%rdx)
  800bb6:	eb 17                	jmp    800bcf <getint+0xb3>
  800bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bc0:	48 89 d0             	mov    %rdx,%rax
  800bc3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bcb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bcf:	48 8b 00             	mov    (%rax),%rax
  800bd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bd6:	eb 4e                	jmp    800c26 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdc:	8b 00                	mov    (%rax),%eax
  800bde:	83 f8 30             	cmp    $0x30,%eax
  800be1:	73 24                	jae    800c07 <getint+0xeb>
  800be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800beb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bef:	8b 00                	mov    (%rax),%eax
  800bf1:	89 c0                	mov    %eax,%eax
  800bf3:	48 01 d0             	add    %rdx,%rax
  800bf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bfa:	8b 12                	mov    (%rdx),%edx
  800bfc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c03:	89 0a                	mov    %ecx,(%rdx)
  800c05:	eb 17                	jmp    800c1e <getint+0x102>
  800c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c0f:	48 89 d0             	mov    %rdx,%rax
  800c12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c1e:	8b 00                	mov    (%rax),%eax
  800c20:	48 98                	cltq   
  800c22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c2a:	c9                   	leaveq 
  800c2b:	c3                   	retq   

0000000000800c2c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c2c:	55                   	push   %rbp
  800c2d:	48 89 e5             	mov    %rsp,%rbp
  800c30:	41 54                	push   %r12
  800c32:	53                   	push   %rbx
  800c33:	48 83 ec 60          	sub    $0x60,%rsp
  800c37:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800c3b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800c3f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c43:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800c47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c4b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c4f:	48 8b 0a             	mov    (%rdx),%rcx
  800c52:	48 89 08             	mov    %rcx,(%rax)
  800c55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c65:	eb 17                	jmp    800c7e <vprintfmt+0x52>
			if (ch == '\0')
  800c67:	85 db                	test   %ebx,%ebx
  800c69:	0f 84 cc 04 00 00    	je     80113b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800c6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c77:	48 89 d6             	mov    %rdx,%rsi
  800c7a:	89 df                	mov    %ebx,%edi
  800c7c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c7e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c82:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c86:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c8a:	0f b6 00             	movzbl (%rax),%eax
  800c8d:	0f b6 d8             	movzbl %al,%ebx
  800c90:	83 fb 25             	cmp    $0x25,%ebx
  800c93:	75 d2                	jne    800c67 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c95:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c99:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800ca0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ca7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800cae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cb5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cb9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800cbd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800cc1:	0f b6 00             	movzbl (%rax),%eax
  800cc4:	0f b6 d8             	movzbl %al,%ebx
  800cc7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800cca:	83 f8 55             	cmp    $0x55,%eax
  800ccd:	0f 87 34 04 00 00    	ja     801107 <vprintfmt+0x4db>
  800cd3:	89 c0                	mov    %eax,%eax
  800cd5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800cdc:	00 
  800cdd:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  800ce4:	00 00 00 
  800ce7:	48 01 d0             	add    %rdx,%rax
  800cea:	48 8b 00             	mov    (%rax),%rax
  800ced:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800cef:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800cf3:	eb c0                	jmp    800cb5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cf5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cf9:	eb ba                	jmp    800cb5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800d02:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800d05:	89 d0                	mov    %edx,%eax
  800d07:	c1 e0 02             	shl    $0x2,%eax
  800d0a:	01 d0                	add    %edx,%eax
  800d0c:	01 c0                	add    %eax,%eax
  800d0e:	01 d8                	add    %ebx,%eax
  800d10:	83 e8 30             	sub    $0x30,%eax
  800d13:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d16:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d1a:	0f b6 00             	movzbl (%rax),%eax
  800d1d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d20:	83 fb 2f             	cmp    $0x2f,%ebx
  800d23:	7e 0c                	jle    800d31 <vprintfmt+0x105>
  800d25:	83 fb 39             	cmp    $0x39,%ebx
  800d28:	7f 07                	jg     800d31 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d2a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d2f:	eb d1                	jmp    800d02 <vprintfmt+0xd6>
			goto process_precision;
  800d31:	eb 58                	jmp    800d8b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800d33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d36:	83 f8 30             	cmp    $0x30,%eax
  800d39:	73 17                	jae    800d52 <vprintfmt+0x126>
  800d3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d42:	89 c0                	mov    %eax,%eax
  800d44:	48 01 d0             	add    %rdx,%rax
  800d47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d4a:	83 c2 08             	add    $0x8,%edx
  800d4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d50:	eb 0f                	jmp    800d61 <vprintfmt+0x135>
  800d52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d56:	48 89 d0             	mov    %rdx,%rax
  800d59:	48 83 c2 08          	add    $0x8,%rdx
  800d5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d61:	8b 00                	mov    (%rax),%eax
  800d63:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d66:	eb 23                	jmp    800d8b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800d68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6c:	79 0c                	jns    800d7a <vprintfmt+0x14e>
				width = 0;
  800d6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d75:	e9 3b ff ff ff       	jmpq   800cb5 <vprintfmt+0x89>
  800d7a:	e9 36 ff ff ff       	jmpq   800cb5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d7f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d86:	e9 2a ff ff ff       	jmpq   800cb5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d8f:	79 12                	jns    800da3 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d91:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d94:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d97:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d9e:	e9 12 ff ff ff       	jmpq   800cb5 <vprintfmt+0x89>
  800da3:	e9 0d ff ff ff       	jmpq   800cb5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800da8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800dac:	e9 04 ff ff ff       	jmpq   800cb5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800db1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db4:	83 f8 30             	cmp    $0x30,%eax
  800db7:	73 17                	jae    800dd0 <vprintfmt+0x1a4>
  800db9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc0:	89 c0                	mov    %eax,%eax
  800dc2:	48 01 d0             	add    %rdx,%rax
  800dc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc8:	83 c2 08             	add    $0x8,%edx
  800dcb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dce:	eb 0f                	jmp    800ddf <vprintfmt+0x1b3>
  800dd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd4:	48 89 d0             	mov    %rdx,%rax
  800dd7:	48 83 c2 08          	add    $0x8,%rdx
  800ddb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ddf:	8b 10                	mov    (%rax),%edx
  800de1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800de5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de9:	48 89 ce             	mov    %rcx,%rsi
  800dec:	89 d7                	mov    %edx,%edi
  800dee:	ff d0                	callq  *%rax
			break;
  800df0:	e9 40 03 00 00       	jmpq   801135 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800df5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800df8:	83 f8 30             	cmp    $0x30,%eax
  800dfb:	73 17                	jae    800e14 <vprintfmt+0x1e8>
  800dfd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e04:	89 c0                	mov    %eax,%eax
  800e06:	48 01 d0             	add    %rdx,%rax
  800e09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e0c:	83 c2 08             	add    $0x8,%edx
  800e0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e12:	eb 0f                	jmp    800e23 <vprintfmt+0x1f7>
  800e14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e18:	48 89 d0             	mov    %rdx,%rax
  800e1b:	48 83 c2 08          	add    $0x8,%rdx
  800e1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e23:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e25:	85 db                	test   %ebx,%ebx
  800e27:	79 02                	jns    800e2b <vprintfmt+0x1ff>
				err = -err;
  800e29:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e2b:	83 fb 15             	cmp    $0x15,%ebx
  800e2e:	7f 16                	jg     800e46 <vprintfmt+0x21a>
  800e30:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800e37:	00 00 00 
  800e3a:	48 63 d3             	movslq %ebx,%rdx
  800e3d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e41:	4d 85 e4             	test   %r12,%r12
  800e44:	75 2e                	jne    800e74 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800e46:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4e:	89 d9                	mov    %ebx,%ecx
  800e50:	48 ba e1 50 80 00 00 	movabs $0x8050e1,%rdx
  800e57:	00 00 00 
  800e5a:	48 89 c7             	mov    %rax,%rdi
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	49 b8 44 11 80 00 00 	movabs $0x801144,%r8
  800e69:	00 00 00 
  800e6c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e6f:	e9 c1 02 00 00       	jmpq   801135 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7c:	4c 89 e1             	mov    %r12,%rcx
  800e7f:	48 ba ea 50 80 00 00 	movabs $0x8050ea,%rdx
  800e86:	00 00 00 
  800e89:	48 89 c7             	mov    %rax,%rdi
  800e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e91:	49 b8 44 11 80 00 00 	movabs $0x801144,%r8
  800e98:	00 00 00 
  800e9b:	41 ff d0             	callq  *%r8
			break;
  800e9e:	e9 92 02 00 00       	jmpq   801135 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ea3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ea6:	83 f8 30             	cmp    $0x30,%eax
  800ea9:	73 17                	jae    800ec2 <vprintfmt+0x296>
  800eab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800eaf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eb2:	89 c0                	mov    %eax,%eax
  800eb4:	48 01 d0             	add    %rdx,%rax
  800eb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eba:	83 c2 08             	add    $0x8,%edx
  800ebd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ec0:	eb 0f                	jmp    800ed1 <vprintfmt+0x2a5>
  800ec2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ec6:	48 89 d0             	mov    %rdx,%rax
  800ec9:	48 83 c2 08          	add    $0x8,%rdx
  800ecd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ed1:	4c 8b 20             	mov    (%rax),%r12
  800ed4:	4d 85 e4             	test   %r12,%r12
  800ed7:	75 0a                	jne    800ee3 <vprintfmt+0x2b7>
				p = "(null)";
  800ed9:	49 bc ed 50 80 00 00 	movabs $0x8050ed,%r12
  800ee0:	00 00 00 
			if (width > 0 && padc != '-')
  800ee3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ee7:	7e 3f                	jle    800f28 <vprintfmt+0x2fc>
  800ee9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800eed:	74 39                	je     800f28 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800eef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ef2:	48 98                	cltq   
  800ef4:	48 89 c6             	mov    %rax,%rsi
  800ef7:	4c 89 e7             	mov    %r12,%rdi
  800efa:	48 b8 f0 13 80 00 00 	movabs $0x8013f0,%rax
  800f01:	00 00 00 
  800f04:	ff d0                	callq  *%rax
  800f06:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800f09:	eb 17                	jmp    800f22 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800f0b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800f0f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f17:	48 89 ce             	mov    %rcx,%rsi
  800f1a:	89 d7                	mov    %edx,%edi
  800f1c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f26:	7f e3                	jg     800f0b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f28:	eb 37                	jmp    800f61 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800f2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f2e:	74 1e                	je     800f4e <vprintfmt+0x322>
  800f30:	83 fb 1f             	cmp    $0x1f,%ebx
  800f33:	7e 05                	jle    800f3a <vprintfmt+0x30e>
  800f35:	83 fb 7e             	cmp    $0x7e,%ebx
  800f38:	7e 14                	jle    800f4e <vprintfmt+0x322>
					putch('?', putdat);
  800f3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f42:	48 89 d6             	mov    %rdx,%rsi
  800f45:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f4a:	ff d0                	callq  *%rax
  800f4c:	eb 0f                	jmp    800f5d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800f4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f56:	48 89 d6             	mov    %rdx,%rsi
  800f59:	89 df                	mov    %ebx,%edi
  800f5b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f61:	4c 89 e0             	mov    %r12,%rax
  800f64:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f68:	0f b6 00             	movzbl (%rax),%eax
  800f6b:	0f be d8             	movsbl %al,%ebx
  800f6e:	85 db                	test   %ebx,%ebx
  800f70:	74 10                	je     800f82 <vprintfmt+0x356>
  800f72:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f76:	78 b2                	js     800f2a <vprintfmt+0x2fe>
  800f78:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f80:	79 a8                	jns    800f2a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f82:	eb 16                	jmp    800f9a <vprintfmt+0x36e>
				putch(' ', putdat);
  800f84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8c:	48 89 d6             	mov    %rdx,%rsi
  800f8f:	bf 20 00 00 00       	mov    $0x20,%edi
  800f94:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f96:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f9e:	7f e4                	jg     800f84 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800fa0:	e9 90 01 00 00       	jmpq   801135 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800fa5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fa9:	be 03 00 00 00       	mov    $0x3,%esi
  800fae:	48 89 c7             	mov    %rax,%rdi
  800fb1:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
  800fbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc5:	48 85 c0             	test   %rax,%rax
  800fc8:	79 1d                	jns    800fe7 <vprintfmt+0x3bb>
				putch('-', putdat);
  800fca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd2:	48 89 d6             	mov    %rdx,%rsi
  800fd5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fda:	ff d0                	callq  *%rax
				num = -(long long) num;
  800fdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe0:	48 f7 d8             	neg    %rax
  800fe3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800fe7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fee:	e9 d5 00 00 00       	jmpq   8010c8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ff3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ff7:	be 03 00 00 00       	mov    $0x3,%esi
  800ffc:	48 89 c7             	mov    %rax,%rdi
  800fff:	48 b8 0c 0a 80 00 00 	movabs $0x800a0c,%rax
  801006:	00 00 00 
  801009:	ff d0                	callq  *%rax
  80100b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80100f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801016:	e9 ad 00 00 00       	jmpq   8010c8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  80101b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80101f:	be 03 00 00 00       	mov    $0x3,%esi
  801024:	48 89 c7             	mov    %rax,%rdi
  801027:	48 b8 0c 0a 80 00 00 	movabs $0x800a0c,%rax
  80102e:	00 00 00 
  801031:	ff d0                	callq  *%rax
  801033:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801037:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80103e:	e9 85 00 00 00       	jmpq   8010c8 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801043:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801047:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80104b:	48 89 d6             	mov    %rdx,%rsi
  80104e:	bf 30 00 00 00       	mov    $0x30,%edi
  801053:	ff d0                	callq  *%rax
			putch('x', putdat);
  801055:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801059:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80105d:	48 89 d6             	mov    %rdx,%rsi
  801060:	bf 78 00 00 00       	mov    $0x78,%edi
  801065:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801067:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80106a:	83 f8 30             	cmp    $0x30,%eax
  80106d:	73 17                	jae    801086 <vprintfmt+0x45a>
  80106f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801073:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801076:	89 c0                	mov    %eax,%eax
  801078:	48 01 d0             	add    %rdx,%rax
  80107b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80107e:	83 c2 08             	add    $0x8,%edx
  801081:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801084:	eb 0f                	jmp    801095 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801086:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80108a:	48 89 d0             	mov    %rdx,%rax
  80108d:	48 83 c2 08          	add    $0x8,%rdx
  801091:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801095:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801098:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80109c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8010a3:	eb 23                	jmp    8010c8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8010a5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010a9:	be 03 00 00 00       	mov    $0x3,%esi
  8010ae:	48 89 c7             	mov    %rax,%rdi
  8010b1:	48 b8 0c 0a 80 00 00 	movabs $0x800a0c,%rax
  8010b8:	00 00 00 
  8010bb:	ff d0                	callq  *%rax
  8010bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8010c1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010cd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010d0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010df:	45 89 c1             	mov    %r8d,%r9d
  8010e2:	41 89 f8             	mov    %edi,%r8d
  8010e5:	48 89 c7             	mov    %rax,%rdi
  8010e8:	48 b8 51 09 80 00 00 	movabs $0x800951,%rax
  8010ef:	00 00 00 
  8010f2:	ff d0                	callq  *%rax
			break;
  8010f4:	eb 3f                	jmp    801135 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010f6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010fe:	48 89 d6             	mov    %rdx,%rsi
  801101:	89 df                	mov    %ebx,%edi
  801103:	ff d0                	callq  *%rax
			break;
  801105:	eb 2e                	jmp    801135 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801107:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80110b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80110f:	48 89 d6             	mov    %rdx,%rsi
  801112:	bf 25 00 00 00       	mov    $0x25,%edi
  801117:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801119:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80111e:	eb 05                	jmp    801125 <vprintfmt+0x4f9>
  801120:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801125:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801129:	48 83 e8 01          	sub    $0x1,%rax
  80112d:	0f b6 00             	movzbl (%rax),%eax
  801130:	3c 25                	cmp    $0x25,%al
  801132:	75 ec                	jne    801120 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801134:	90                   	nop
		}
	}
  801135:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	e9 43 fb ff ff       	jmpq   800c7e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80113b:	48 83 c4 60          	add    $0x60,%rsp
  80113f:	5b                   	pop    %rbx
  801140:	41 5c                	pop    %r12
  801142:	5d                   	pop    %rbp
  801143:	c3                   	retq   

0000000000801144 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801144:	55                   	push   %rbp
  801145:	48 89 e5             	mov    %rsp,%rbp
  801148:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80114f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801156:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80115d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801164:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80116b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801172:	84 c0                	test   %al,%al
  801174:	74 20                	je     801196 <printfmt+0x52>
  801176:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80117a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80117e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801182:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801186:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80118a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80118e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801192:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801196:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80119d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8011a4:	00 00 00 
  8011a7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8011ae:	00 00 00 
  8011b1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011b5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8011bc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011c3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011ca:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011d1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011d8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011df:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011e6:	48 89 c7             	mov    %rax,%rdi
  8011e9:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  8011f0:	00 00 00 
  8011f3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011f5:	c9                   	leaveq 
  8011f6:	c3                   	retq   

00000000008011f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011f7:	55                   	push   %rbp
  8011f8:	48 89 e5             	mov    %rsp,%rbp
  8011fb:	48 83 ec 10          	sub    $0x10,%rsp
  8011ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120a:	8b 40 10             	mov    0x10(%rax),%eax
  80120d:	8d 50 01             	lea    0x1(%rax),%edx
  801210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801214:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121b:	48 8b 10             	mov    (%rax),%rdx
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	48 8b 40 08          	mov    0x8(%rax),%rax
  801226:	48 39 c2             	cmp    %rax,%rdx
  801229:	73 17                	jae    801242 <sprintputch+0x4b>
		*b->buf++ = ch;
  80122b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122f:	48 8b 00             	mov    (%rax),%rax
  801232:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801236:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80123a:	48 89 0a             	mov    %rcx,(%rdx)
  80123d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801240:	88 10                	mov    %dl,(%rax)
}
  801242:	c9                   	leaveq 
  801243:	c3                   	retq   

0000000000801244 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	48 83 ec 50          	sub    $0x50,%rsp
  80124c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801250:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801253:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801257:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80125b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80125f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801263:	48 8b 0a             	mov    (%rdx),%rcx
  801266:	48 89 08             	mov    %rcx,(%rax)
  801269:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80126d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801271:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801275:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801279:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80127d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801281:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801284:	48 98                	cltq   
  801286:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80128a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80128e:	48 01 d0             	add    %rdx,%rax
  801291:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801295:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80129c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8012a1:	74 06                	je     8012a9 <vsnprintf+0x65>
  8012a3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8012a7:	7f 07                	jg     8012b0 <vsnprintf+0x6c>
		return -E_INVAL;
  8012a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ae:	eb 2f                	jmp    8012df <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8012b0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8012b4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8012b8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012bc:	48 89 c6             	mov    %rax,%rsi
  8012bf:	48 bf f7 11 80 00 00 	movabs $0x8011f7,%rdi
  8012c6:	00 00 00 
  8012c9:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  8012d0:	00 00 00 
  8012d3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012d9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012dc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012df:	c9                   	leaveq 
  8012e0:	c3                   	retq   

00000000008012e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012ec:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012f3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801300:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801307:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80130e:	84 c0                	test   %al,%al
  801310:	74 20                	je     801332 <snprintf+0x51>
  801312:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801316:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80131a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80131e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801322:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801326:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80132a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80132e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801332:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801339:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801340:	00 00 00 
  801343:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80134a:	00 00 00 
  80134d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801351:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801358:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80135f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801366:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80136d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801374:	48 8b 0a             	mov    (%rdx),%rcx
  801377:	48 89 08             	mov    %rcx,(%rax)
  80137a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80137e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801382:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801386:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80138a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801391:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801398:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80139e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8013a5:	48 89 c7             	mov    %rax,%rdi
  8013a8:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  8013af:	00 00 00 
  8013b2:	ff d0                	callq  *%rax
  8013b4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8013ba:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013c0:	c9                   	leaveq 
  8013c1:	c3                   	retq   

00000000008013c2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013c2:	55                   	push   %rbp
  8013c3:	48 89 e5             	mov    %rsp,%rbp
  8013c6:	48 83 ec 18          	sub    $0x18,%rsp
  8013ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013d5:	eb 09                	jmp    8013e0 <strlen+0x1e>
		n++;
  8013d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013db:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	84 c0                	test   %al,%al
  8013e9:	75 ec                	jne    8013d7 <strlen+0x15>
		n++;
	return n;
  8013eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ee:	c9                   	leaveq 
  8013ef:	c3                   	retq   

00000000008013f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013f0:	55                   	push   %rbp
  8013f1:	48 89 e5             	mov    %rsp,%rbp
  8013f4:	48 83 ec 20          	sub    $0x20,%rsp
  8013f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801407:	eb 0e                	jmp    801417 <strnlen+0x27>
		n++;
  801409:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801412:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801417:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80141c:	74 0b                	je     801429 <strnlen+0x39>
  80141e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	84 c0                	test   %al,%al
  801427:	75 e0                	jne    801409 <strnlen+0x19>
		n++;
	return n;
  801429:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80142c:	c9                   	leaveq 
  80142d:	c3                   	retq   

000000000080142e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80142e:	55                   	push   %rbp
  80142f:	48 89 e5             	mov    %rsp,%rbp
  801432:	48 83 ec 20          	sub    $0x20,%rsp
  801436:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80143a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80144f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801453:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801457:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80145b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80145f:	0f b6 12             	movzbl (%rdx),%edx
  801462:	88 10                	mov    %dl,(%rax)
  801464:	0f b6 00             	movzbl (%rax),%eax
  801467:	84 c0                	test   %al,%al
  801469:	75 dc                	jne    801447 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80146b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80146f:	c9                   	leaveq 
  801470:	c3                   	retq   

0000000000801471 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801471:	55                   	push   %rbp
  801472:	48 89 e5             	mov    %rsp,%rbp
  801475:	48 83 ec 20          	sub    $0x20,%rsp
  801479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801485:	48 89 c7             	mov    %rax,%rdi
  801488:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  80148f:	00 00 00 
  801492:	ff d0                	callq  *%rax
  801494:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80149a:	48 63 d0             	movslq %eax,%rdx
  80149d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a1:	48 01 c2             	add    %rax,%rdx
  8014a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a8:	48 89 c6             	mov    %rax,%rsi
  8014ab:	48 89 d7             	mov    %rdx,%rdi
  8014ae:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8014b5:	00 00 00 
  8014b8:	ff d0                	callq  *%rax
	return dst;
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014be:	c9                   	leaveq 
  8014bf:	c3                   	retq   

00000000008014c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 28          	sub    $0x28,%rsp
  8014c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014dc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014e3:	00 
  8014e4:	eb 2a                	jmp    801510 <strncpy+0x50>
		*dst++ = *src;
  8014e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014f6:	0f b6 12             	movzbl (%rdx),%edx
  8014f9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	84 c0                	test   %al,%al
  801504:	74 05                	je     80150b <strncpy+0x4b>
			src++;
  801506:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80150b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801514:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801518:	72 cc                	jb     8014e6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80151a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80151e:	c9                   	leaveq 
  80151f:	c3                   	retq   

0000000000801520 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801520:	55                   	push   %rbp
  801521:	48 89 e5             	mov    %rsp,%rbp
  801524:	48 83 ec 28          	sub    $0x28,%rsp
  801528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801530:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801538:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80153c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801541:	74 3d                	je     801580 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801543:	eb 1d                	jmp    801562 <strlcpy+0x42>
			*dst++ = *src++;
  801545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801549:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80154d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801551:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801555:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801559:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80155d:	0f b6 12             	movzbl (%rdx),%edx
  801560:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801562:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801567:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80156c:	74 0b                	je     801579 <strlcpy+0x59>
  80156e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	84 c0                	test   %al,%al
  801577:	75 cc                	jne    801545 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801588:	48 29 c2             	sub    %rax,%rdx
  80158b:	48 89 d0             	mov    %rdx,%rax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 83 ec 10          	sub    $0x10,%rsp
  801598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015a0:	eb 0a                	jmp    8015ac <strcmp+0x1c>
		p++, q++;
  8015a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b0:	0f b6 00             	movzbl (%rax),%eax
  8015b3:	84 c0                	test   %al,%al
  8015b5:	74 12                	je     8015c9 <strcmp+0x39>
  8015b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bb:	0f b6 10             	movzbl (%rax),%edx
  8015be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	38 c2                	cmp    %al,%dl
  8015c7:	74 d9                	je     8015a2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cd:	0f b6 00             	movzbl (%rax),%eax
  8015d0:	0f b6 d0             	movzbl %al,%edx
  8015d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d7:	0f b6 00             	movzbl (%rax),%eax
  8015da:	0f b6 c0             	movzbl %al,%eax
  8015dd:	29 c2                	sub    %eax,%edx
  8015df:	89 d0                	mov    %edx,%eax
}
  8015e1:	c9                   	leaveq 
  8015e2:	c3                   	retq   

00000000008015e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	48 83 ec 18          	sub    $0x18,%rsp
  8015eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015f7:	eb 0f                	jmp    801608 <strncmp+0x25>
		n--, p++, q++;
  8015f9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801603:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801608:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80160d:	74 1d                	je     80162c <strncmp+0x49>
  80160f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	84 c0                	test   %al,%al
  801618:	74 12                	je     80162c <strncmp+0x49>
  80161a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161e:	0f b6 10             	movzbl (%rax),%edx
  801621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801625:	0f b6 00             	movzbl (%rax),%eax
  801628:	38 c2                	cmp    %al,%dl
  80162a:	74 cd                	je     8015f9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80162c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801631:	75 07                	jne    80163a <strncmp+0x57>
		return 0;
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	eb 18                	jmp    801652 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80163a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	0f b6 d0             	movzbl %al,%edx
  801644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	0f b6 c0             	movzbl %al,%eax
  80164e:	29 c2                	sub    %eax,%edx
  801650:	89 d0                	mov    %edx,%eax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 0c          	sub    $0xc,%rsp
  80165c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801660:	89 f0                	mov    %esi,%eax
  801662:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801665:	eb 17                	jmp    80167e <strchr+0x2a>
		if (*s == c)
  801667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801671:	75 06                	jne    801679 <strchr+0x25>
			return (char *) s;
  801673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801677:	eb 15                	jmp    80168e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801679:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80167e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	84 c0                	test   %al,%al
  801687:	75 de                	jne    801667 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168e:	c9                   	leaveq 
  80168f:	c3                   	retq   

0000000000801690 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801690:	55                   	push   %rbp
  801691:	48 89 e5             	mov    %rsp,%rbp
  801694:	48 83 ec 0c          	sub    $0xc,%rsp
  801698:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169c:	89 f0                	mov    %esi,%eax
  80169e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016a1:	eb 13                	jmp    8016b6 <strfind+0x26>
		if (*s == c)
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016ad:	75 02                	jne    8016b1 <strfind+0x21>
			break;
  8016af:	eb 10                	jmp    8016c1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	84 c0                	test   %al,%al
  8016bf:	75 e2                	jne    8016a3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016c5:	c9                   	leaveq 
  8016c6:	c3                   	retq   

00000000008016c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016c7:	55                   	push   %rbp
  8016c8:	48 89 e5             	mov    %rsp,%rbp
  8016cb:	48 83 ec 18          	sub    $0x18,%rsp
  8016cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016df:	75 06                	jne    8016e7 <memset+0x20>
		return v;
  8016e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e5:	eb 69                	jmp    801750 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016eb:	83 e0 03             	and    $0x3,%eax
  8016ee:	48 85 c0             	test   %rax,%rax
  8016f1:	75 48                	jne    80173b <memset+0x74>
  8016f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f7:	83 e0 03             	and    $0x3,%eax
  8016fa:	48 85 c0             	test   %rax,%rax
  8016fd:	75 3c                	jne    80173b <memset+0x74>
		c &= 0xFF;
  8016ff:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801706:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801709:	c1 e0 18             	shl    $0x18,%eax
  80170c:	89 c2                	mov    %eax,%edx
  80170e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801711:	c1 e0 10             	shl    $0x10,%eax
  801714:	09 c2                	or     %eax,%edx
  801716:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801719:	c1 e0 08             	shl    $0x8,%eax
  80171c:	09 d0                	or     %edx,%eax
  80171e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801725:	48 c1 e8 02          	shr    $0x2,%rax
  801729:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80172c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801730:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801733:	48 89 d7             	mov    %rdx,%rdi
  801736:	fc                   	cld    
  801737:	f3 ab                	rep stos %eax,%es:(%rdi)
  801739:	eb 11                	jmp    80174c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80173b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80173f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801742:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801746:	48 89 d7             	mov    %rdx,%rdi
  801749:	fc                   	cld    
  80174a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80174c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801750:	c9                   	leaveq 
  801751:	c3                   	retq   

0000000000801752 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801752:	55                   	push   %rbp
  801753:	48 89 e5             	mov    %rsp,%rbp
  801756:	48 83 ec 28          	sub    $0x28,%rsp
  80175a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80175e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801762:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801766:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80176a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80176e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801772:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80177e:	0f 83 88 00 00 00    	jae    80180c <memmove+0xba>
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80178c:	48 01 d0             	add    %rdx,%rax
  80178f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801793:	76 77                	jbe    80180c <memmove+0xba>
		s += n;
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a9:	83 e0 03             	and    $0x3,%eax
  8017ac:	48 85 c0             	test   %rax,%rax
  8017af:	75 3b                	jne    8017ec <memmove+0x9a>
  8017b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b5:	83 e0 03             	and    $0x3,%eax
  8017b8:	48 85 c0             	test   %rax,%rax
  8017bb:	75 2f                	jne    8017ec <memmove+0x9a>
  8017bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c1:	83 e0 03             	and    $0x3,%eax
  8017c4:	48 85 c0             	test   %rax,%rax
  8017c7:	75 23                	jne    8017ec <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cd:	48 83 e8 04          	sub    $0x4,%rax
  8017d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d5:	48 83 ea 04          	sub    $0x4,%rdx
  8017d9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017dd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017e1:	48 89 c7             	mov    %rax,%rdi
  8017e4:	48 89 d6             	mov    %rdx,%rsi
  8017e7:	fd                   	std    
  8017e8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ea:	eb 1d                	jmp    801809 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	48 89 d7             	mov    %rdx,%rdi
  801803:	48 89 c1             	mov    %rax,%rcx
  801806:	fd                   	std    
  801807:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801809:	fc                   	cld    
  80180a:	eb 57                	jmp    801863 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80180c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801810:	83 e0 03             	and    $0x3,%eax
  801813:	48 85 c0             	test   %rax,%rax
  801816:	75 36                	jne    80184e <memmove+0xfc>
  801818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181c:	83 e0 03             	and    $0x3,%eax
  80181f:	48 85 c0             	test   %rax,%rax
  801822:	75 2a                	jne    80184e <memmove+0xfc>
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	83 e0 03             	and    $0x3,%eax
  80182b:	48 85 c0             	test   %rax,%rax
  80182e:	75 1e                	jne    80184e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	48 c1 e8 02          	shr    $0x2,%rax
  801838:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80183b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80183f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801843:	48 89 c7             	mov    %rax,%rdi
  801846:	48 89 d6             	mov    %rdx,%rsi
  801849:	fc                   	cld    
  80184a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80184c:	eb 15                	jmp    801863 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80184e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801852:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801856:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80185a:	48 89 c7             	mov    %rax,%rdi
  80185d:	48 89 d6             	mov    %rdx,%rsi
  801860:	fc                   	cld    
  801861:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801867:	c9                   	leaveq 
  801868:	c3                   	retq   

0000000000801869 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801869:	55                   	push   %rbp
  80186a:	48 89 e5             	mov    %rsp,%rbp
  80186d:	48 83 ec 18          	sub    $0x18,%rsp
  801871:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801875:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801879:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80187d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801881:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801885:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801889:	48 89 ce             	mov    %rcx,%rsi
  80188c:	48 89 c7             	mov    %rax,%rdi
  80188f:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  801896:	00 00 00 
  801899:	ff d0                	callq  *%rax
}
  80189b:	c9                   	leaveq 
  80189c:	c3                   	retq   

000000000080189d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
  8018a1:	48 83 ec 28          	sub    $0x28,%rsp
  8018a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018c1:	eb 36                	jmp    8018f9 <memcmp+0x5c>
		if (*s1 != *s2)
  8018c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c7:	0f b6 10             	movzbl (%rax),%edx
  8018ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	38 c2                	cmp    %al,%dl
  8018d3:	74 1a                	je     8018ef <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d9:	0f b6 00             	movzbl (%rax),%eax
  8018dc:	0f b6 d0             	movzbl %al,%edx
  8018df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	0f b6 c0             	movzbl %al,%eax
  8018e9:	29 c2                	sub    %eax,%edx
  8018eb:	89 d0                	mov    %edx,%eax
  8018ed:	eb 20                	jmp    80190f <memcmp+0x72>
		s1++, s2++;
  8018ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801901:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801905:	48 85 c0             	test   %rax,%rax
  801908:	75 b9                	jne    8018c3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 28          	sub    $0x28,%rsp
  801919:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80191d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801920:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801928:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80192c:	48 01 d0             	add    %rdx,%rax
  80192f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801933:	eb 15                	jmp    80194a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801939:	0f b6 10             	movzbl (%rax),%edx
  80193c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80193f:	38 c2                	cmp    %al,%dl
  801941:	75 02                	jne    801945 <memfind+0x34>
			break;
  801943:	eb 0f                	jmp    801954 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801945:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80194a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80194e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801952:	72 e1                	jb     801935 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801958:	c9                   	leaveq 
  801959:	c3                   	retq   

000000000080195a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80195a:	55                   	push   %rbp
  80195b:	48 89 e5             	mov    %rsp,%rbp
  80195e:	48 83 ec 34          	sub    $0x34,%rsp
  801962:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801966:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80196a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80196d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801974:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80197b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80197c:	eb 05                	jmp    801983 <strtol+0x29>
		s++;
  80197e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801983:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801987:	0f b6 00             	movzbl (%rax),%eax
  80198a:	3c 20                	cmp    $0x20,%al
  80198c:	74 f0                	je     80197e <strtol+0x24>
  80198e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801992:	0f b6 00             	movzbl (%rax),%eax
  801995:	3c 09                	cmp    $0x9,%al
  801997:	74 e5                	je     80197e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801999:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199d:	0f b6 00             	movzbl (%rax),%eax
  8019a0:	3c 2b                	cmp    $0x2b,%al
  8019a2:	75 07                	jne    8019ab <strtol+0x51>
		s++;
  8019a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019a9:	eb 17                	jmp    8019c2 <strtol+0x68>
	else if (*s == '-')
  8019ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	3c 2d                	cmp    $0x2d,%al
  8019b4:	75 0c                	jne    8019c2 <strtol+0x68>
		s++, neg = 1;
  8019b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019c6:	74 06                	je     8019ce <strtol+0x74>
  8019c8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019cc:	75 28                	jne    8019f6 <strtol+0x9c>
  8019ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d2:	0f b6 00             	movzbl (%rax),%eax
  8019d5:	3c 30                	cmp    $0x30,%al
  8019d7:	75 1d                	jne    8019f6 <strtol+0x9c>
  8019d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dd:	48 83 c0 01          	add    $0x1,%rax
  8019e1:	0f b6 00             	movzbl (%rax),%eax
  8019e4:	3c 78                	cmp    $0x78,%al
  8019e6:	75 0e                	jne    8019f6 <strtol+0x9c>
		s += 2, base = 16;
  8019e8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019ed:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019f4:	eb 2c                	jmp    801a22 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019fa:	75 19                	jne    801a15 <strtol+0xbb>
  8019fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a00:	0f b6 00             	movzbl (%rax),%eax
  801a03:	3c 30                	cmp    $0x30,%al
  801a05:	75 0e                	jne    801a15 <strtol+0xbb>
		s++, base = 8;
  801a07:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a0c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a13:	eb 0d                	jmp    801a22 <strtol+0xc8>
	else if (base == 0)
  801a15:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a19:	75 07                	jne    801a22 <strtol+0xc8>
		base = 10;
  801a1b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a26:	0f b6 00             	movzbl (%rax),%eax
  801a29:	3c 2f                	cmp    $0x2f,%al
  801a2b:	7e 1d                	jle    801a4a <strtol+0xf0>
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	0f b6 00             	movzbl (%rax),%eax
  801a34:	3c 39                	cmp    $0x39,%al
  801a36:	7f 12                	jg     801a4a <strtol+0xf0>
			dig = *s - '0';
  801a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3c:	0f b6 00             	movzbl (%rax),%eax
  801a3f:	0f be c0             	movsbl %al,%eax
  801a42:	83 e8 30             	sub    $0x30,%eax
  801a45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a48:	eb 4e                	jmp    801a98 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4e:	0f b6 00             	movzbl (%rax),%eax
  801a51:	3c 60                	cmp    $0x60,%al
  801a53:	7e 1d                	jle    801a72 <strtol+0x118>
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	0f b6 00             	movzbl (%rax),%eax
  801a5c:	3c 7a                	cmp    $0x7a,%al
  801a5e:	7f 12                	jg     801a72 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	0f b6 00             	movzbl (%rax),%eax
  801a67:	0f be c0             	movsbl %al,%eax
  801a6a:	83 e8 57             	sub    $0x57,%eax
  801a6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a70:	eb 26                	jmp    801a98 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a76:	0f b6 00             	movzbl (%rax),%eax
  801a79:	3c 40                	cmp    $0x40,%al
  801a7b:	7e 48                	jle    801ac5 <strtol+0x16b>
  801a7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a81:	0f b6 00             	movzbl (%rax),%eax
  801a84:	3c 5a                	cmp    $0x5a,%al
  801a86:	7f 3d                	jg     801ac5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8c:	0f b6 00             	movzbl (%rax),%eax
  801a8f:	0f be c0             	movsbl %al,%eax
  801a92:	83 e8 37             	sub    $0x37,%eax
  801a95:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a9b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a9e:	7c 02                	jl     801aa2 <strtol+0x148>
			break;
  801aa0:	eb 23                	jmp    801ac5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801aa2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801aa7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801aaa:	48 98                	cltq   
  801aac:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ab7:	48 98                	cltq   
  801ab9:	48 01 d0             	add    %rdx,%rax
  801abc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ac0:	e9 5d ff ff ff       	jmpq   801a22 <strtol+0xc8>

	if (endptr)
  801ac5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801aca:	74 0b                	je     801ad7 <strtol+0x17d>
		*endptr = (char *) s;
  801acc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ad0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ad4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ad7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801adb:	74 09                	je     801ae6 <strtol+0x18c>
  801add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae1:	48 f7 d8             	neg    %rax
  801ae4:	eb 04                	jmp    801aea <strtol+0x190>
  801ae6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801aea:	c9                   	leaveq 
  801aeb:	c3                   	retq   

0000000000801aec <strstr>:

char * strstr(const char *in, const char *str)
{
  801aec:	55                   	push   %rbp
  801aed:	48 89 e5             	mov    %rsp,%rbp
  801af0:	48 83 ec 30          	sub    $0x30,%rsp
  801af4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801af8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801afc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b00:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b04:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b08:	0f b6 00             	movzbl (%rax),%eax
  801b0b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b0e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b12:	75 06                	jne    801b1a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b18:	eb 6b                	jmp    801b85 <strstr+0x99>

	len = strlen(str);
  801b1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b1e:	48 89 c7             	mov    %rax,%rdi
  801b21:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  801b28:	00 00 00 
  801b2b:	ff d0                	callq  *%rax
  801b2d:	48 98                	cltq   
  801b2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b37:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b3f:	0f b6 00             	movzbl (%rax),%eax
  801b42:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b45:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b49:	75 07                	jne    801b52 <strstr+0x66>
				return (char *) 0;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b50:	eb 33                	jmp    801b85 <strstr+0x99>
		} while (sc != c);
  801b52:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b56:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b59:	75 d8                	jne    801b33 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b67:	48 89 ce             	mov    %rcx,%rsi
  801b6a:	48 89 c7             	mov    %rax,%rdi
  801b6d:	48 b8 e3 15 80 00 00 	movabs $0x8015e3,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	callq  *%rax
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	75 b6                	jne    801b33 <strstr+0x47>

	return (char *) (in - 1);
  801b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b81:	48 83 e8 01          	sub    $0x1,%rax
}
  801b85:	c9                   	leaveq 
  801b86:	c3                   	retq   

0000000000801b87 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	53                   	push   %rbx
  801b8c:	48 83 ec 48          	sub    $0x48,%rsp
  801b90:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b93:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b96:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b9a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b9e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ba2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ba6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ba9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801bad:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801bb1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801bb5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bb9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bbd:	4c 89 c3             	mov    %r8,%rbx
  801bc0:	cd 30                	int    $0x30
  801bc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bc6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bca:	74 3e                	je     801c0a <syscall+0x83>
  801bcc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bd1:	7e 37                	jle    801c0a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bd7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bda:	49 89 d0             	mov    %rdx,%r8
  801bdd:	89 c1                	mov    %eax,%ecx
  801bdf:	48 ba a8 53 80 00 00 	movabs $0x8053a8,%rdx
  801be6:	00 00 00 
  801be9:	be 24 00 00 00       	mov    $0x24,%esi
  801bee:	48 bf c5 53 80 00 00 	movabs $0x8053c5,%rdi
  801bf5:	00 00 00 
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfd:	49 b9 40 06 80 00 00 	movabs $0x800640,%r9
  801c04:	00 00 00 
  801c07:	41 ff d1             	callq  *%r9

	return ret;
  801c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c0e:	48 83 c4 48          	add    $0x48,%rsp
  801c12:	5b                   	pop    %rbx
  801c13:	5d                   	pop    %rbp
  801c14:	c3                   	retq   

0000000000801c15 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c15:	55                   	push   %rbp
  801c16:	48 89 e5             	mov    %rsp,%rbp
  801c19:	48 83 ec 20          	sub    $0x20,%rsp
  801c1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c34:	00 
  801c35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c41:	48 89 d1             	mov    %rdx,%rcx
  801c44:	48 89 c2             	mov    %rax,%rdx
  801c47:	be 00 00 00 00       	mov    $0x0,%esi
  801c4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c51:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801c58:	00 00 00 
  801c5b:	ff d0                	callq  *%rax
}
  801c5d:	c9                   	leaveq 
  801c5e:	c3                   	retq   

0000000000801c5f <sys_cgetc>:

int
sys_cgetc(void)
{
  801c5f:	55                   	push   %rbp
  801c60:	48 89 e5             	mov    %rsp,%rbp
  801c63:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6e:	00 
  801c6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c80:	ba 00 00 00 00       	mov    $0x0,%edx
  801c85:	be 00 00 00 00       	mov    $0x0,%esi
  801c8a:	bf 01 00 00 00       	mov    $0x1,%edi
  801c8f:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801c96:	00 00 00 
  801c99:	ff d0                	callq  *%rax
}
  801c9b:	c9                   	leaveq 
  801c9c:	c3                   	retq   

0000000000801c9d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c9d:	55                   	push   %rbp
  801c9e:	48 89 e5             	mov    %rsp,%rbp
  801ca1:	48 83 ec 10          	sub    $0x10,%rsp
  801ca5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cab:	48 98                	cltq   
  801cad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb4:	00 
  801cb5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc6:	48 89 c2             	mov    %rax,%rdx
  801cc9:	be 01 00 00 00       	mov    $0x1,%esi
  801cce:	bf 03 00 00 00       	mov    $0x3,%edi
  801cd3:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
}
  801cdf:	c9                   	leaveq 
  801ce0:	c3                   	retq   

0000000000801ce1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ce9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf0:	00 
  801cf1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
  801d07:	be 00 00 00 00       	mov    $0x0,%esi
  801d0c:	bf 02 00 00 00       	mov    $0x2,%edi
  801d11:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_yield>:


void
sys_yield(void)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2e:	00 
  801d2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d40:	ba 00 00 00 00       	mov    $0x0,%edx
  801d45:	be 00 00 00 00       	mov    $0x0,%esi
  801d4a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d4f:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801d56:	00 00 00 
  801d59:	ff d0                	callq  *%rax
}
  801d5b:	c9                   	leaveq 
  801d5c:	c3                   	retq   

0000000000801d5d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d5d:	55                   	push   %rbp
  801d5e:	48 89 e5             	mov    %rsp,%rbp
  801d61:	48 83 ec 20          	sub    $0x20,%rsp
  801d65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d6c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d72:	48 63 c8             	movslq %eax,%rcx
  801d75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7c:	48 98                	cltq   
  801d7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d85:	00 
  801d86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8c:	49 89 c8             	mov    %rcx,%r8
  801d8f:	48 89 d1             	mov    %rdx,%rcx
  801d92:	48 89 c2             	mov    %rax,%rdx
  801d95:	be 01 00 00 00       	mov    $0x1,%esi
  801d9a:	bf 04 00 00 00       	mov    $0x4,%edi
  801d9f:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 30          	sub    $0x30,%rsp
  801db5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dbc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dbf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dc3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dc7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dca:	48 63 c8             	movslq %eax,%rcx
  801dcd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd4:	48 63 f0             	movslq %eax,%rsi
  801dd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dde:	48 98                	cltq   
  801de0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801de4:	49 89 f9             	mov    %rdi,%r9
  801de7:	49 89 f0             	mov    %rsi,%r8
  801dea:	48 89 d1             	mov    %rdx,%rcx
  801ded:	48 89 c2             	mov    %rax,%rdx
  801df0:	be 01 00 00 00       	mov    $0x1,%esi
  801df5:	bf 05 00 00 00       	mov    $0x5,%edi
  801dfa:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801e01:	00 00 00 
  801e04:	ff d0                	callq  *%rax
}
  801e06:	c9                   	leaveq 
  801e07:	c3                   	retq   

0000000000801e08 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e08:	55                   	push   %rbp
  801e09:	48 89 e5             	mov    %rsp,%rbp
  801e0c:	48 83 ec 20          	sub    $0x20,%rsp
  801e10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1e:	48 98                	cltq   
  801e20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e27:	00 
  801e28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e34:	48 89 d1             	mov    %rdx,%rcx
  801e37:	48 89 c2             	mov    %rax,%rdx
  801e3a:	be 01 00 00 00       	mov    $0x1,%esi
  801e3f:	bf 06 00 00 00       	mov    $0x6,%edi
  801e44:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801e4b:	00 00 00 
  801e4e:	ff d0                	callq  *%rax
}
  801e50:	c9                   	leaveq 
  801e51:	c3                   	retq   

0000000000801e52 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e52:	55                   	push   %rbp
  801e53:	48 89 e5             	mov    %rsp,%rbp
  801e56:	48 83 ec 10          	sub    $0x10,%rsp
  801e5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e5d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e63:	48 63 d0             	movslq %eax,%rdx
  801e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e69:	48 98                	cltq   
  801e6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e72:	00 
  801e73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7f:	48 89 d1             	mov    %rdx,%rcx
  801e82:	48 89 c2             	mov    %rax,%rdx
  801e85:	be 01 00 00 00       	mov    $0x1,%esi
  801e8a:	bf 08 00 00 00       	mov    $0x8,%edi
  801e8f:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801e96:	00 00 00 
  801e99:	ff d0                	callq  *%rax
}
  801e9b:	c9                   	leaveq 
  801e9c:	c3                   	retq   

0000000000801e9d <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e9d:	55                   	push   %rbp
  801e9e:	48 89 e5             	mov    %rsp,%rbp
  801ea1:	48 83 ec 20          	sub    $0x20,%rsp
  801ea5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ea8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801eac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb3:	48 98                	cltq   
  801eb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ebc:	00 
  801ebd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec9:	48 89 d1             	mov    %rdx,%rcx
  801ecc:	48 89 c2             	mov    %rax,%rdx
  801ecf:	be 01 00 00 00       	mov    $0x1,%esi
  801ed4:	bf 09 00 00 00       	mov    $0x9,%edi
  801ed9:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	callq  *%rax
}
  801ee5:	c9                   	leaveq 
  801ee6:	c3                   	retq   

0000000000801ee7 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ee7:	55                   	push   %rbp
  801ee8:	48 89 e5             	mov    %rsp,%rbp
  801eeb:	48 83 ec 20          	sub    $0x20,%rsp
  801eef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ef2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ef6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efd:	48 98                	cltq   
  801eff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f06:	00 
  801f07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f13:	48 89 d1             	mov    %rdx,%rcx
  801f16:	48 89 c2             	mov    %rax,%rdx
  801f19:	be 01 00 00 00       	mov    $0x1,%esi
  801f1e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f23:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	callq  *%rax
}
  801f2f:	c9                   	leaveq 
  801f30:	c3                   	retq   

0000000000801f31 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f31:	55                   	push   %rbp
  801f32:	48 89 e5             	mov    %rsp,%rbp
  801f35:	48 83 ec 20          	sub    $0x20,%rsp
  801f39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f40:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f44:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f4a:	48 63 f0             	movslq %eax,%rsi
  801f4d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f54:	48 98                	cltq   
  801f56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f61:	00 
  801f62:	49 89 f1             	mov    %rsi,%r9
  801f65:	49 89 c8             	mov    %rcx,%r8
  801f68:	48 89 d1             	mov    %rdx,%rcx
  801f6b:	48 89 c2             	mov    %rax,%rdx
  801f6e:	be 00 00 00 00       	mov    $0x0,%esi
  801f73:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f78:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	callq  *%rax
}
  801f84:	c9                   	leaveq 
  801f85:	c3                   	retq   

0000000000801f86 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f86:	55                   	push   %rbp
  801f87:	48 89 e5             	mov    %rsp,%rbp
  801f8a:	48 83 ec 10          	sub    $0x10,%rsp
  801f8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f9d:	00 
  801f9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fa4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801faa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801faf:	48 89 c2             	mov    %rax,%rdx
  801fb2:	be 01 00 00 00       	mov    $0x1,%esi
  801fb7:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fbc:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
}
  801fc8:	c9                   	leaveq 
  801fc9:	c3                   	retq   

0000000000801fca <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801fca:	55                   	push   %rbp
  801fcb:	48 89 e5             	mov    %rsp,%rbp
  801fce:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd9:	00 
  801fda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	be 00 00 00 00       	mov    $0x0,%esi
  801ff5:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ffa:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802001:	00 00 00 
  802004:	ff d0                	callq  *%rax
}
  802006:	c9                   	leaveq 
  802007:	c3                   	retq   

0000000000802008 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  802008:	55                   	push   %rbp
  802009:	48 89 e5             	mov    %rsp,%rbp
  80200c:	48 83 ec 20          	sub    $0x20,%rsp
  802010:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802014:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  802017:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80201a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802025:	00 
  802026:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802032:	48 89 d1             	mov    %rdx,%rcx
  802035:	48 89 c2             	mov    %rax,%rdx
  802038:	be 00 00 00 00       	mov    $0x0,%esi
  80203d:	bf 0f 00 00 00       	mov    $0xf,%edi
  802042:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802049:	00 00 00 
  80204c:	ff d0                	callq  *%rax
}
  80204e:	c9                   	leaveq 
  80204f:	c3                   	retq   

0000000000802050 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802050:	55                   	push   %rbp
  802051:	48 89 e5             	mov    %rsp,%rbp
  802054:	48 83 ec 20          	sub    $0x20,%rsp
  802058:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80205c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  80205f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802066:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80206d:	00 
  80206e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802074:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80207a:	48 89 d1             	mov    %rdx,%rcx
  80207d:	48 89 c2             	mov    %rax,%rdx
  802080:	be 00 00 00 00       	mov    $0x0,%esi
  802085:	bf 10 00 00 00       	mov    $0x10,%edi
  80208a:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802091:	00 00 00 
  802094:	ff d0                	callq  *%rax
}
  802096:	c9                   	leaveq 
  802097:	c3                   	retq   

0000000000802098 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802098:	55                   	push   %rbp
  802099:	48 89 e5             	mov    %rsp,%rbp
  80209c:	48 83 ec 30          	sub    $0x30,%rsp
  8020a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020a7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020aa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020ae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8020b2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020b5:	48 63 c8             	movslq %eax,%rcx
  8020b8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020bf:	48 63 f0             	movslq %eax,%rsi
  8020c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c9:	48 98                	cltq   
  8020cb:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020cf:	49 89 f9             	mov    %rdi,%r9
  8020d2:	49 89 f0             	mov    %rsi,%r8
  8020d5:	48 89 d1             	mov    %rdx,%rcx
  8020d8:	48 89 c2             	mov    %rax,%rdx
  8020db:	be 00 00 00 00       	mov    $0x0,%esi
  8020e0:	bf 11 00 00 00       	mov    $0x11,%edi
  8020e5:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8020ec:	00 00 00 
  8020ef:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8020f1:	c9                   	leaveq 
  8020f2:	c3                   	retq   

00000000008020f3 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8020f3:	55                   	push   %rbp
  8020f4:	48 89 e5             	mov    %rsp,%rbp
  8020f7:	48 83 ec 20          	sub    $0x20,%rsp
  8020fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802103:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802107:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80210b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802112:	00 
  802113:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802119:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211f:	48 89 d1             	mov    %rdx,%rcx
  802122:	48 89 c2             	mov    %rax,%rdx
  802125:	be 00 00 00 00       	mov    $0x0,%esi
  80212a:	bf 12 00 00 00       	mov    $0x12,%edi
  80212f:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802136:	00 00 00 
  802139:	ff d0                	callq  *%rax
}
  80213b:	c9                   	leaveq 
  80213c:	c3                   	retq   

000000000080213d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80213d:	55                   	push   %rbp
  80213e:	48 89 e5             	mov    %rsp,%rbp
  802141:	48 83 ec 30          	sub    $0x30,%rsp
  802145:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802149:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214d:	48 8b 00             	mov    (%rax),%rax
  802150:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  802154:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802158:	48 8b 40 08          	mov    0x8(%rax),%rax
  80215c:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  80215f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802162:	83 e0 02             	and    $0x2,%eax
  802165:	85 c0                	test   %eax,%eax
  802167:	75 40                	jne    8021a9 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802169:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216d:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802178:	49 89 d0             	mov    %rdx,%r8
  80217b:	48 89 c1             	mov    %rax,%rcx
  80217e:	48 ba d8 53 80 00 00 	movabs $0x8053d8,%rdx
  802185:	00 00 00 
  802188:	be 1f 00 00 00       	mov    $0x1f,%esi
  80218d:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802194:	00 00 00 
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	49 b9 40 06 80 00 00 	movabs $0x800640,%r9
  8021a3:	00 00 00 
  8021a6:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  8021a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b1:	48 89 c2             	mov    %rax,%rdx
  8021b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021bb:	01 00 00 
  8021be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c2:	25 07 08 00 00       	and    $0x807,%eax
  8021c7:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  8021cd:	74 4e                	je     80221d <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  8021cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d7:	48 89 c2             	mov    %rax,%rdx
  8021da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e1:	01 00 00 
  8021e4:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8021e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021ec:	49 89 d0             	mov    %rdx,%r8
  8021ef:	48 89 c1             	mov    %rax,%rcx
  8021f2:	48 ba 00 54 80 00 00 	movabs $0x805400,%rdx
  8021f9:	00 00 00 
  8021fc:	be 22 00 00 00       	mov    $0x22,%esi
  802201:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802208:	00 00 00 
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
  802210:	49 b9 40 06 80 00 00 	movabs $0x800640,%r9
  802217:	00 00 00 
  80221a:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80221d:	ba 07 00 00 00       	mov    $0x7,%edx
  802222:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802227:	bf 00 00 00 00       	mov    $0x0,%edi
  80222c:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  802233:	00 00 00 
  802236:	ff d0                	callq  *%rax
  802238:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80223b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80223f:	79 30                	jns    802271 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  802241:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802244:	89 c1                	mov    %eax,%ecx
  802246:	48 ba 2b 54 80 00 00 	movabs $0x80542b,%rdx
  80224d:	00 00 00 
  802250:	be 28 00 00 00       	mov    $0x28,%esi
  802255:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  80225c:	00 00 00 
  80225f:	b8 00 00 00 00       	mov    $0x0,%eax
  802264:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  80226b:	00 00 00 
  80226e:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  802271:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802275:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80227d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802283:	ba 00 10 00 00       	mov    $0x1000,%edx
  802288:	48 89 c6             	mov    %rax,%rsi
  80228b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802290:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  802297:	00 00 00 
  80229a:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80229c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8022ae:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8022b4:	48 89 c1             	mov    %rax,%rcx
  8022b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022bc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c6:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  8022cd:	00 00 00 
  8022d0:	ff d0                	callq  *%rax
  8022d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8022d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022d9:	79 30                	jns    80230b <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  8022db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022de:	89 c1                	mov    %eax,%ecx
  8022e0:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  8022e7:	00 00 00 
  8022ea:	be 2d 00 00 00       	mov    $0x2d,%esi
  8022ef:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8022f6:	00 00 00 
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  802305:	00 00 00 
  802308:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  80230b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802310:	bf 00 00 00 00       	mov    $0x0,%edi
  802315:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax
  802321:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802324:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802328:	79 30                	jns    80235a <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  80232a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80232d:	89 c1                	mov    %eax,%ecx
  80232f:	48 ba 4f 54 80 00 00 	movabs $0x80544f,%rdx
  802336:	00 00 00 
  802339:	be 31 00 00 00       	mov    $0x31,%esi
  80233e:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802345:	00 00 00 
  802348:	b8 00 00 00 00       	mov    $0x0,%eax
  80234d:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  802354:	00 00 00 
  802357:	41 ff d0             	callq  *%r8

}
  80235a:	c9                   	leaveq 
  80235b:	c3                   	retq   

000000000080235c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80235c:	55                   	push   %rbp
  80235d:	48 89 e5             	mov    %rsp,%rbp
  802360:	48 83 ec 30          	sub    $0x30,%rsp
  802364:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802367:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80236a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80236d:	c1 e0 0c             	shl    $0xc,%eax
  802370:	89 c0                	mov    %eax,%eax
  802372:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802376:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80237d:	01 00 00 
  802380:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802383:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802387:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80238b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238f:	25 02 08 00 00       	and    $0x802,%eax
  802394:	48 85 c0             	test   %rax,%rax
  802397:	74 0e                	je     8023a7 <duppage+0x4b>
  802399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239d:	25 00 04 00 00       	and    $0x400,%eax
  8023a2:	48 85 c0             	test   %rax,%rax
  8023a5:	74 70                	je     802417 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8023a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8023b0:	89 c6                	mov    %eax,%esi
  8023b2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8023b6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023bd:	41 89 f0             	mov    %esi,%r8d
  8023c0:	48 89 c6             	mov    %rax,%rsi
  8023c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c8:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  8023cf:	00 00 00 
  8023d2:	ff d0                	callq  *%rax
  8023d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8023d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023db:	79 30                	jns    80240d <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8023dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e0:	89 c1                	mov    %eax,%ecx
  8023e2:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  8023e9:	00 00 00 
  8023ec:	be 50 00 00 00       	mov    $0x50,%esi
  8023f1:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8023f8:	00 00 00 
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802400:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  802407:	00 00 00 
  80240a:	41 ff d0             	callq  *%r8
		return 0;
  80240d:	b8 00 00 00 00       	mov    $0x0,%eax
  802412:	e9 c4 00 00 00       	jmpq   8024db <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802417:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80241b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80241e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802422:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802428:	48 89 c6             	mov    %rax,%rsi
  80242b:	bf 00 00 00 00       	mov    $0x0,%edi
  802430:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802437:	00 00 00 
  80243a:	ff d0                	callq  *%rax
  80243c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80243f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802443:	79 30                	jns    802475 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802445:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802448:	89 c1                	mov    %eax,%ecx
  80244a:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  802451:	00 00 00 
  802454:	be 64 00 00 00       	mov    $0x64,%esi
  802459:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802460:	00 00 00 
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
  802468:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  80246f:	00 00 00 
  802472:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802475:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247d:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802483:	48 89 d1             	mov    %rdx,%rcx
  802486:	ba 00 00 00 00       	mov    $0x0,%edx
  80248b:	48 89 c6             	mov    %rax,%rsi
  80248e:	bf 00 00 00 00       	mov    $0x0,%edi
  802493:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  80249a:	00 00 00 
  80249d:	ff d0                	callq  *%rax
  80249f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024a6:	79 30                	jns    8024d8 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8024a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024ab:	89 c1                	mov    %eax,%ecx
  8024ad:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  8024b4:	00 00 00 
  8024b7:	be 66 00 00 00       	mov    $0x66,%esi
  8024bc:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8024c3:	00 00 00 
  8024c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cb:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  8024d2:	00 00 00 
  8024d5:	41 ff d0             	callq  *%r8
	return r;
  8024d8:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8024e5:	48 bf 3d 21 80 00 00 	movabs $0x80213d,%rdi
  8024ec:	00 00 00 
  8024ef:	48 b8 44 4b 80 00 00 	movabs $0x804b44,%rax
  8024f6:	00 00 00 
  8024f9:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8024fb:	b8 07 00 00 00       	mov    $0x7,%eax
  802500:	cd 30                	int    $0x30
  802502:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802505:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802508:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80250b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80250f:	79 08                	jns    802519 <fork+0x3c>
		return envid;
  802511:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802514:	e9 09 02 00 00       	jmpq   802722 <fork+0x245>
	if (envid == 0) {
  802519:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80251d:	75 3e                	jne    80255d <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80251f:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  802526:	00 00 00 
  802529:	ff d0                	callq  *%rax
  80252b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802530:	48 98                	cltq   
  802532:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802539:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802540:	00 00 00 
  802543:	48 01 c2             	add    %rax,%rdx
  802546:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80254d:	00 00 00 
  802550:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	e9 c5 01 00 00       	jmpq   802722 <fork+0x245>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80255d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802564:	e9 a4 00 00 00       	jmpq   80260d <fork+0x130>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802569:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256c:	c1 f8 12             	sar    $0x12,%eax
  80256f:	89 c2                	mov    %eax,%edx
  802571:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802578:	01 00 00 
  80257b:	48 63 d2             	movslq %edx,%rdx
  80257e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802582:	83 e0 01             	and    $0x1,%eax
  802585:	48 85 c0             	test   %rax,%rax
  802588:	74 21                	je     8025ab <fork+0xce>
  80258a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258d:	c1 f8 09             	sar    $0x9,%eax
  802590:	89 c2                	mov    %eax,%edx
  802592:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802599:	01 00 00 
  80259c:	48 63 d2             	movslq %edx,%rdx
  80259f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a3:	83 e0 01             	and    $0x1,%eax
  8025a6:	48 85 c0             	test   %rax,%rax
  8025a9:	75 09                	jne    8025b4 <fork+0xd7>
			pn += NPTENTRIES;
  8025ab:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8025b2:	eb 59                	jmp    80260d <fork+0x130>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8025b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b7:	05 00 02 00 00       	add    $0x200,%eax
  8025bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8025bf:	eb 44                	jmp    802605 <fork+0x128>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8025c1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025c8:	01 00 00 
  8025cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025ce:	48 63 d2             	movslq %edx,%rdx
  8025d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d5:	83 e0 05             	and    $0x5,%eax
  8025d8:	48 83 f8 05          	cmp    $0x5,%rax
  8025dc:	74 02                	je     8025e0 <fork+0x103>
				continue;
  8025de:	eb 21                	jmp    802601 <fork+0x124>
			if (pn == PPN(UXSTACKTOP - 1))
  8025e0:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8025e7:	75 02                	jne    8025eb <fork+0x10e>
				continue;
  8025e9:	eb 16                	jmp    802601 <fork+0x124>
			duppage(envid, pn);
  8025eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025f1:	89 d6                	mov    %edx,%esi
  8025f3:	89 c7                	mov    %eax,%edi
  8025f5:	48 b8 5c 23 80 00 00 	movabs $0x80235c,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802601:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802608:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80260b:	7c b4                	jl     8025c1 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80260d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802610:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802615:	0f 86 4e ff ff ff    	jbe    802569 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80261b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80261e:	ba 07 00 00 00       	mov    $0x7,%edx
  802623:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802628:	89 c7                	mov    %eax,%edi
  80262a:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  802631:	00 00 00 
  802634:	ff d0                	callq  *%rax
  802636:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802639:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80263d:	79 30                	jns    80266f <fork+0x192>
		panic("allocating exception stack: %e", r);
  80263f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802642:	89 c1                	mov    %eax,%ecx
  802644:	48 ba 68 54 80 00 00 	movabs $0x805468,%rdx
  80264b:	00 00 00 
  80264e:	be 9e 00 00 00       	mov    $0x9e,%esi
  802653:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  80265a:	00 00 00 
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  802669:	00 00 00 
  80266c:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  80266f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802676:	00 00 00 
  802679:	48 8b 00             	mov    (%rax),%rax
  80267c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802683:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802686:	48 89 d6             	mov    %rdx,%rsi
  802689:	89 c7                	mov    %eax,%edi
  80268b:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  802692:	00 00 00 
  802695:	ff d0                	callq  *%rax
  802697:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80269a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80269e:	79 30                	jns    8026d0 <fork+0x1f3>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8026a0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026a3:	89 c1                	mov    %eax,%ecx
  8026a5:	48 ba 88 54 80 00 00 	movabs $0x805488,%rdx
  8026ac:	00 00 00 
  8026af:	be a2 00 00 00       	mov    $0xa2,%esi
  8026b4:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8026bb:	00 00 00 
  8026be:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c3:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  8026ca:	00 00 00 
  8026cd:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8026d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026d3:	be 02 00 00 00       	mov    $0x2,%esi
  8026d8:	89 c7                	mov    %eax,%edi
  8026da:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
  8026e6:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8026e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026ed:	79 30                	jns    80271f <fork+0x242>
		panic("sys_env_set_status: %e", r);
  8026ef:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026f2:	89 c1                	mov    %eax,%ecx
  8026f4:	48 ba a7 54 80 00 00 	movabs $0x8054a7,%rdx
  8026fb:	00 00 00 
  8026fe:	be a7 00 00 00       	mov    $0xa7,%esi
  802703:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  80270a:	00 00 00 
  80270d:	b8 00 00 00 00       	mov    $0x0,%eax
  802712:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  802719:	00 00 00 
  80271c:	41 ff d0             	callq  *%r8

	return envid;
  80271f:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802722:	c9                   	leaveq 
  802723:	c3                   	retq   

0000000000802724 <sfork>:

// Challenge!
int
sfork(void)
{
  802724:	55                   	push   %rbp
  802725:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802728:	48 ba be 54 80 00 00 	movabs $0x8054be,%rdx
  80272f:	00 00 00 
  802732:	be b1 00 00 00       	mov    $0xb1,%esi
  802737:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  80273e:	00 00 00 
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	48 b9 40 06 80 00 00 	movabs $0x800640,%rcx
  80274d:	00 00 00 
  802750:	ff d1                	callq  *%rcx

0000000000802752 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802752:	55                   	push   %rbp
  802753:	48 89 e5             	mov    %rsp,%rbp
  802756:	48 83 ec 30          	sub    $0x30,%rsp
  80275a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80275e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802762:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802766:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80276b:	75 0e                	jne    80277b <ipc_recv+0x29>
		pg = (void*) UTOP;
  80276d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802774:	00 00 00 
  802777:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80277b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80277f:	48 89 c7             	mov    %rax,%rdi
  802782:	48 b8 86 1f 80 00 00 	movabs $0x801f86,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
  80278e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802791:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802795:	79 27                	jns    8027be <ipc_recv+0x6c>
		if (from_env_store)
  802797:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80279c:	74 0a                	je     8027a8 <ipc_recv+0x56>
			*from_env_store = 0;
  80279e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8027a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027ad:	74 0a                	je     8027b9 <ipc_recv+0x67>
			*perm_store = 0;
  8027af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8027b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bc:	eb 53                	jmp    802811 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8027be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027c3:	74 19                	je     8027de <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8027c5:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8027cc:	00 00 00 
  8027cf:	48 8b 00             	mov    (%rax),%rax
  8027d2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8027d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027dc:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8027de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027e3:	74 19                	je     8027fe <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8027e5:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8027ec:	00 00 00 
  8027ef:	48 8b 00             	mov    (%rax),%rax
  8027f2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8027f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027fc:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8027fe:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802805:	00 00 00 
  802808:	48 8b 00             	mov    (%rax),%rax
  80280b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802811:	c9                   	leaveq 
  802812:	c3                   	retq   

0000000000802813 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802813:	55                   	push   %rbp
  802814:	48 89 e5             	mov    %rsp,%rbp
  802817:	48 83 ec 30          	sub    $0x30,%rsp
  80281b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80281e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802821:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802825:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802828:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80282d:	75 10                	jne    80283f <ipc_send+0x2c>
		pg = (void*) UTOP;
  80282f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802836:	00 00 00 
  802839:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80283d:	eb 0e                	jmp    80284d <ipc_send+0x3a>
  80283f:	eb 0c                	jmp    80284d <ipc_send+0x3a>
		sys_yield();
  802841:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  802848:	00 00 00 
  80284b:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80284d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802850:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802853:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802857:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80285a:	89 c7                	mov    %eax,%edi
  80285c:	48 b8 31 1f 80 00 00 	movabs $0x801f31,%rax
  802863:	00 00 00 
  802866:	ff d0                	callq  *%rax
  802868:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80286f:	74 d0                	je     802841 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  802871:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802875:	79 30                	jns    8028a7 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  802877:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287a:	89 c1                	mov    %eax,%ecx
  80287c:	48 ba d4 54 80 00 00 	movabs $0x8054d4,%rdx
  802883:	00 00 00 
  802886:	be 47 00 00 00       	mov    $0x47,%esi
  80288b:	48 bf ea 54 80 00 00 	movabs $0x8054ea,%rdi
  802892:	00 00 00 
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
  80289a:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  8028a1:	00 00 00 
  8028a4:	41 ff d0             	callq  *%r8

}
  8028a7:	c9                   	leaveq 
  8028a8:	c3                   	retq   

00000000008028a9 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8028a9:	55                   	push   %rbp
  8028aa:	48 89 e5             	mov    %rsp,%rbp
  8028ad:	53                   	push   %rbx
  8028ae:	48 83 ec 28          	sub    $0x28,%rsp
  8028b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8028b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8028bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8028c4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028c9:	75 0e                	jne    8028d9 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8028cb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028d2:	00 00 00 
  8028d5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8028d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028dd:	ba 07 00 00 00       	mov    $0x7,%edx
  8028e2:	48 89 c6             	mov    %rax,%rsi
  8028e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ea:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8028f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8028fe:	48 89 c2             	mov    %rax,%rdx
  802901:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802908:	01 00 00 
  80290b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802915:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  802919:	b8 03 00 00 00       	mov    $0x3,%eax
  80291e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802922:	48 89 d3             	mov    %rdx,%rbx
  802925:	0f 01 c1             	vmcall 
  802928:	89 f2                	mov    %esi,%edx
  80292a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80292d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  802930:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802934:	79 05                	jns    80293b <ipc_host_recv+0x92>
		return r;
  802936:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802939:	eb 03                	jmp    80293e <ipc_host_recv+0x95>
	}
	return val;
  80293b:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80293e:	48 83 c4 28          	add    $0x28,%rsp
  802942:	5b                   	pop    %rbx
  802943:	5d                   	pop    %rbp
  802944:	c3                   	retq   

0000000000802945 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802945:	55                   	push   %rbp
  802946:	48 89 e5             	mov    %rsp,%rbp
  802949:	53                   	push   %rbx
  80294a:	48 83 ec 38          	sub    $0x38,%rsp
  80294e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802951:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802954:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802958:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80295b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  802962:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802967:	75 0e                	jne    802977 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802969:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802970:	00 00 00 
  802973:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802977:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80297b:	48 c1 e8 0c          	shr    $0xc,%rax
  80297f:	48 89 c2             	mov    %rax,%rdx
  802982:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802989:	01 00 00 
  80298c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802990:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802996:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  80299a:	b8 02 00 00 00       	mov    $0x2,%eax
  80299f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8029a2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029a5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029a9:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8029ac:	89 fb                	mov    %edi,%ebx
  8029ae:	0f 01 c1             	vmcall 
  8029b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8029b4:	eb 26                	jmp    8029dc <ipc_host_send+0x97>
		sys_yield();
  8029b6:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8029c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8029c7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8029ca:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029d1:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8029d4:	89 fb                	mov    %edi,%ebx
  8029d6:	0f 01 c1             	vmcall 
  8029d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8029dc:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8029e0:	74 d4                	je     8029b6 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8029e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029e6:	79 30                	jns    802a18 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8029e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029eb:	89 c1                	mov    %eax,%ecx
  8029ed:	48 ba d4 54 80 00 00 	movabs $0x8054d4,%rdx
  8029f4:	00 00 00 
  8029f7:	be 79 00 00 00       	mov    $0x79,%esi
  8029fc:	48 bf ea 54 80 00 00 	movabs $0x8054ea,%rdi
  802a03:	00 00 00 
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0b:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  802a12:	00 00 00 
  802a15:	41 ff d0             	callq  *%r8

}
  802a18:	48 83 c4 38          	add    $0x38,%rsp
  802a1c:	5b                   	pop    %rbx
  802a1d:	5d                   	pop    %rbp
  802a1e:	c3                   	retq   

0000000000802a1f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a1f:	55                   	push   %rbp
  802a20:	48 89 e5             	mov    %rsp,%rbp
  802a23:	48 83 ec 14          	sub    $0x14,%rsp
  802a27:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802a2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a31:	eb 4e                	jmp    802a81 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802a33:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a3a:	00 00 00 
  802a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a40:	48 98                	cltq   
  802a42:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a49:	48 01 d0             	add    %rdx,%rax
  802a4c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802a52:	8b 00                	mov    (%rax),%eax
  802a54:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a57:	75 24                	jne    802a7d <ipc_find_env+0x5e>
			return envs[i].env_id;
  802a59:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a60:	00 00 00 
  802a63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a66:	48 98                	cltq   
  802a68:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a6f:	48 01 d0             	add    %rdx,%rax
  802a72:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802a78:	8b 40 08             	mov    0x8(%rax),%eax
  802a7b:	eb 12                	jmp    802a8f <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802a7d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a81:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a88:	7e a9                	jle    802a33 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8f:	c9                   	leaveq 
  802a90:	c3                   	retq   

0000000000802a91 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a91:	55                   	push   %rbp
  802a92:	48 89 e5             	mov    %rsp,%rbp
  802a95:	48 83 ec 08          	sub    $0x8,%rsp
  802a99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a9d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802aa1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802aa8:	ff ff ff 
  802aab:	48 01 d0             	add    %rdx,%rax
  802aae:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802ab2:	c9                   	leaveq 
  802ab3:	c3                   	retq   

0000000000802ab4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802ab4:	55                   	push   %rbp
  802ab5:	48 89 e5             	mov    %rsp,%rbp
  802ab8:	48 83 ec 08          	sub    $0x8,%rsp
  802abc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac4:	48 89 c7             	mov    %rax,%rdi
  802ac7:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	callq  *%rax
  802ad3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802ad9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802add:	c9                   	leaveq 
  802ade:	c3                   	retq   

0000000000802adf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802adf:	55                   	push   %rbp
  802ae0:	48 89 e5             	mov    %rsp,%rbp
  802ae3:	48 83 ec 18          	sub    $0x18,%rsp
  802ae7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802aeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802af2:	eb 6b                	jmp    802b5f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af7:	48 98                	cltq   
  802af9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802aff:	48 c1 e0 0c          	shl    $0xc,%rax
  802b03:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0b:	48 c1 e8 15          	shr    $0x15,%rax
  802b0f:	48 89 c2             	mov    %rax,%rdx
  802b12:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b19:	01 00 00 
  802b1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b20:	83 e0 01             	and    $0x1,%eax
  802b23:	48 85 c0             	test   %rax,%rax
  802b26:	74 21                	je     802b49 <fd_alloc+0x6a>
  802b28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2c:	48 c1 e8 0c          	shr    $0xc,%rax
  802b30:	48 89 c2             	mov    %rax,%rdx
  802b33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b3a:	01 00 00 
  802b3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b41:	83 e0 01             	and    $0x1,%eax
  802b44:	48 85 c0             	test   %rax,%rax
  802b47:	75 12                	jne    802b5b <fd_alloc+0x7c>
			*fd_store = fd;
  802b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b51:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b54:	b8 00 00 00 00       	mov    $0x0,%eax
  802b59:	eb 1a                	jmp    802b75 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b5b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b5f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b63:	7e 8f                	jle    802af4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b69:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b70:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b75:	c9                   	leaveq 
  802b76:	c3                   	retq   

0000000000802b77 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b77:	55                   	push   %rbp
  802b78:	48 89 e5             	mov    %rsp,%rbp
  802b7b:	48 83 ec 20          	sub    $0x20,%rsp
  802b7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b86:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b8a:	78 06                	js     802b92 <fd_lookup+0x1b>
  802b8c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b90:	7e 07                	jle    802b99 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b97:	eb 6c                	jmp    802c05 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b9c:	48 98                	cltq   
  802b9e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ba4:	48 c1 e0 0c          	shl    $0xc,%rax
  802ba8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb0:	48 c1 e8 15          	shr    $0x15,%rax
  802bb4:	48 89 c2             	mov    %rax,%rdx
  802bb7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bbe:	01 00 00 
  802bc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bc5:	83 e0 01             	and    $0x1,%eax
  802bc8:	48 85 c0             	test   %rax,%rax
  802bcb:	74 21                	je     802bee <fd_lookup+0x77>
  802bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd1:	48 c1 e8 0c          	shr    $0xc,%rax
  802bd5:	48 89 c2             	mov    %rax,%rdx
  802bd8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bdf:	01 00 00 
  802be2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802be6:	83 e0 01             	and    $0x1,%eax
  802be9:	48 85 c0             	test   %rax,%rax
  802bec:	75 07                	jne    802bf5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bf3:	eb 10                	jmp    802c05 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802bf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bfd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c05:	c9                   	leaveq 
  802c06:	c3                   	retq   

0000000000802c07 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802c07:	55                   	push   %rbp
  802c08:	48 89 e5             	mov    %rsp,%rbp
  802c0b:	48 83 ec 30          	sub    $0x30,%rsp
  802c0f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c13:	89 f0                	mov    %esi,%eax
  802c15:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c1c:	48 89 c7             	mov    %rax,%rdi
  802c1f:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
  802c2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c2f:	48 89 d6             	mov    %rdx,%rsi
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c47:	78 0a                	js     802c53 <fd_close+0x4c>
	    || fd != fd2)
  802c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c51:	74 12                	je     802c65 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802c53:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c57:	74 05                	je     802c5e <fd_close+0x57>
  802c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5c:	eb 05                	jmp    802c63 <fd_close+0x5c>
  802c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c63:	eb 69                	jmp    802cce <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c69:	8b 00                	mov    (%rax),%eax
  802c6b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c6f:	48 89 d6             	mov    %rdx,%rsi
  802c72:	89 c7                	mov    %eax,%edi
  802c74:	48 b8 d0 2c 80 00 00 	movabs $0x802cd0,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	callq  *%rax
  802c80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c87:	78 2a                	js     802cb3 <fd_close+0xac>
		if (dev->dev_close)
  802c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c91:	48 85 c0             	test   %rax,%rax
  802c94:	74 16                	je     802cac <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9a:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c9e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ca2:	48 89 d7             	mov    %rdx,%rdi
  802ca5:	ff d0                	callq  *%rax
  802ca7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802caa:	eb 07                	jmp    802cb3 <fd_close+0xac>
		else
			r = 0;
  802cac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802cb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb7:	48 89 c6             	mov    %rax,%rsi
  802cba:	bf 00 00 00 00       	mov    $0x0,%edi
  802cbf:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax
	return r;
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cce:	c9                   	leaveq 
  802ccf:	c3                   	retq   

0000000000802cd0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802cd0:	55                   	push   %rbp
  802cd1:	48 89 e5             	mov    %rsp,%rbp
  802cd4:	48 83 ec 20          	sub    $0x20,%rsp
  802cd8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802cdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ce6:	eb 41                	jmp    802d29 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802ce8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802cef:	00 00 00 
  802cf2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cf5:	48 63 d2             	movslq %edx,%rdx
  802cf8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cfc:	8b 00                	mov    (%rax),%eax
  802cfe:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802d01:	75 22                	jne    802d25 <dev_lookup+0x55>
			*dev = devtab[i];
  802d03:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d0a:	00 00 00 
  802d0d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d10:	48 63 d2             	movslq %edx,%rdx
  802d13:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d1b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d23:	eb 60                	jmp    802d85 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d25:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d29:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d30:	00 00 00 
  802d33:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d36:	48 63 d2             	movslq %edx,%rdx
  802d39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d3d:	48 85 c0             	test   %rax,%rax
  802d40:	75 a6                	jne    802ce8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d42:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802d49:	00 00 00 
  802d4c:	48 8b 00             	mov    (%rax),%rax
  802d4f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d55:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d58:	89 c6                	mov    %eax,%esi
  802d5a:	48 bf f8 54 80 00 00 	movabs $0x8054f8,%rdi
  802d61:	00 00 00 
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
  802d69:	48 b9 79 08 80 00 00 	movabs $0x800879,%rcx
  802d70:	00 00 00 
  802d73:	ff d1                	callq  *%rcx
	*dev = 0;
  802d75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d79:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d85:	c9                   	leaveq 
  802d86:	c3                   	retq   

0000000000802d87 <close>:

int
close(int fdnum)
{
  802d87:	55                   	push   %rbp
  802d88:	48 89 e5             	mov    %rsp,%rbp
  802d8b:	48 83 ec 20          	sub    $0x20,%rsp
  802d8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d99:	48 89 d6             	mov    %rdx,%rsi
  802d9c:	89 c7                	mov    %eax,%edi
  802d9e:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
  802daa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db1:	79 05                	jns    802db8 <close+0x31>
		return r;
  802db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db6:	eb 18                	jmp    802dd0 <close+0x49>
	else
		return fd_close(fd, 1);
  802db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbc:	be 01 00 00 00       	mov    $0x1,%esi
  802dc1:	48 89 c7             	mov    %rax,%rdi
  802dc4:	48 b8 07 2c 80 00 00 	movabs $0x802c07,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
}
  802dd0:	c9                   	leaveq 
  802dd1:	c3                   	retq   

0000000000802dd2 <close_all>:

void
close_all(void)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802dda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802de1:	eb 15                	jmp    802df8 <close_all+0x26>
		close(i);
  802de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de6:	89 c7                	mov    %eax,%edi
  802de8:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  802def:	00 00 00 
  802df2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802df4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802df8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802dfc:	7e e5                	jle    802de3 <close_all+0x11>
		close(i);
}
  802dfe:	c9                   	leaveq 
  802dff:	c3                   	retq   

0000000000802e00 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e00:	55                   	push   %rbp
  802e01:	48 89 e5             	mov    %rsp,%rbp
  802e04:	48 83 ec 40          	sub    $0x40,%rsp
  802e08:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e0b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e0e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e12:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e15:	48 89 d6             	mov    %rdx,%rsi
  802e18:	89 c7                	mov    %eax,%edi
  802e1a:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	callq  *%rax
  802e26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2d:	79 08                	jns    802e37 <dup+0x37>
		return r;
  802e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e32:	e9 70 01 00 00       	jmpq   802fa7 <dup+0x1a7>
	close(newfdnum);
  802e37:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e3a:	89 c7                	mov    %eax,%edi
  802e3c:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e48:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e4b:	48 98                	cltq   
  802e4d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e53:	48 c1 e0 0c          	shl    $0xc,%rax
  802e57:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e5f:	48 89 c7             	mov    %rax,%rdi
  802e62:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
  802e6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e76:	48 89 c7             	mov    %rax,%rdi
  802e79:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  802e80:	00 00 00 
  802e83:	ff d0                	callq  *%rax
  802e85:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8d:	48 c1 e8 15          	shr    $0x15,%rax
  802e91:	48 89 c2             	mov    %rax,%rdx
  802e94:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e9b:	01 00 00 
  802e9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ea2:	83 e0 01             	and    $0x1,%eax
  802ea5:	48 85 c0             	test   %rax,%rax
  802ea8:	74 73                	je     802f1d <dup+0x11d>
  802eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eae:	48 c1 e8 0c          	shr    $0xc,%rax
  802eb2:	48 89 c2             	mov    %rax,%rdx
  802eb5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ebc:	01 00 00 
  802ebf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ec3:	83 e0 01             	and    $0x1,%eax
  802ec6:	48 85 c0             	test   %rax,%rax
  802ec9:	74 52                	je     802f1d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ecb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ecf:	48 c1 e8 0c          	shr    $0xc,%rax
  802ed3:	48 89 c2             	mov    %rax,%rdx
  802ed6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802edd:	01 00 00 
  802ee0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ee4:	25 07 0e 00 00       	and    $0xe07,%eax
  802ee9:	89 c1                	mov    %eax,%ecx
  802eeb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef3:	41 89 c8             	mov    %ecx,%r8d
  802ef6:	48 89 d1             	mov    %rdx,%rcx
  802ef9:	ba 00 00 00 00       	mov    $0x0,%edx
  802efe:	48 89 c6             	mov    %rax,%rsi
  802f01:	bf 00 00 00 00       	mov    $0x0,%edi
  802f06:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
  802f12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f19:	79 02                	jns    802f1d <dup+0x11d>
			goto err;
  802f1b:	eb 57                	jmp    802f74 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f21:	48 c1 e8 0c          	shr    $0xc,%rax
  802f25:	48 89 c2             	mov    %rax,%rdx
  802f28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f2f:	01 00 00 
  802f32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f36:	25 07 0e 00 00       	and    $0xe07,%eax
  802f3b:	89 c1                	mov    %eax,%ecx
  802f3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f45:	41 89 c8             	mov    %ecx,%r8d
  802f48:	48 89 d1             	mov    %rdx,%rcx
  802f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802f50:	48 89 c6             	mov    %rax,%rsi
  802f53:	bf 00 00 00 00       	mov    $0x0,%edi
  802f58:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802f5f:	00 00 00 
  802f62:	ff d0                	callq  *%rax
  802f64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6b:	79 02                	jns    802f6f <dup+0x16f>
		goto err;
  802f6d:	eb 05                	jmp    802f74 <dup+0x174>

	return newfdnum;
  802f6f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f72:	eb 33                	jmp    802fa7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f78:	48 89 c6             	mov    %rax,%rsi
  802f7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f80:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802f87:	00 00 00 
  802f8a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f90:	48 89 c6             	mov    %rax,%rsi
  802f93:	bf 00 00 00 00       	mov    $0x0,%edi
  802f98:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
	return r;
  802fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fa7:	c9                   	leaveq 
  802fa8:	c3                   	retq   

0000000000802fa9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802fa9:	55                   	push   %rbp
  802faa:	48 89 e5             	mov    %rsp,%rbp
  802fad:	48 83 ec 40          	sub    $0x40,%rsp
  802fb1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fb4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fb8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fbc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fc3:	48 89 d6             	mov    %rdx,%rsi
  802fc6:	89 c7                	mov    %eax,%edi
  802fc8:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
  802fd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fdb:	78 24                	js     803001 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe1:	8b 00                	mov    (%rax),%eax
  802fe3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fe7:	48 89 d6             	mov    %rdx,%rsi
  802fea:	89 c7                	mov    %eax,%edi
  802fec:	48 b8 d0 2c 80 00 00 	movabs $0x802cd0,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
  802ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fff:	79 05                	jns    803006 <read+0x5d>
		return r;
  803001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803004:	eb 76                	jmp    80307c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803006:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300a:	8b 40 08             	mov    0x8(%rax),%eax
  80300d:	83 e0 03             	and    $0x3,%eax
  803010:	83 f8 01             	cmp    $0x1,%eax
  803013:	75 3a                	jne    80304f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803015:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80301c:	00 00 00 
  80301f:	48 8b 00             	mov    (%rax),%rax
  803022:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803028:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80302b:	89 c6                	mov    %eax,%esi
  80302d:	48 bf 17 55 80 00 00 	movabs $0x805517,%rdi
  803034:	00 00 00 
  803037:	b8 00 00 00 00       	mov    $0x0,%eax
  80303c:	48 b9 79 08 80 00 00 	movabs $0x800879,%rcx
  803043:	00 00 00 
  803046:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803048:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80304d:	eb 2d                	jmp    80307c <read+0xd3>
	}
	if (!dev->dev_read)
  80304f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803053:	48 8b 40 10          	mov    0x10(%rax),%rax
  803057:	48 85 c0             	test   %rax,%rax
  80305a:	75 07                	jne    803063 <read+0xba>
		return -E_NOT_SUPP;
  80305c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803061:	eb 19                	jmp    80307c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803063:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803067:	48 8b 40 10          	mov    0x10(%rax),%rax
  80306b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80306f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803073:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803077:	48 89 cf             	mov    %rcx,%rdi
  80307a:	ff d0                	callq  *%rax
}
  80307c:	c9                   	leaveq 
  80307d:	c3                   	retq   

000000000080307e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80307e:	55                   	push   %rbp
  80307f:	48 89 e5             	mov    %rsp,%rbp
  803082:	48 83 ec 30          	sub    $0x30,%rsp
  803086:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803089:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80308d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803091:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803098:	eb 49                	jmp    8030e3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80309a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309d:	48 98                	cltq   
  80309f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030a3:	48 29 c2             	sub    %rax,%rdx
  8030a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a9:	48 63 c8             	movslq %eax,%rcx
  8030ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b0:	48 01 c1             	add    %rax,%rcx
  8030b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b6:	48 89 ce             	mov    %rcx,%rsi
  8030b9:	89 c7                	mov    %eax,%edi
  8030bb:	48 b8 a9 2f 80 00 00 	movabs $0x802fa9,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
  8030c7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8030ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030ce:	79 05                	jns    8030d5 <readn+0x57>
			return m;
  8030d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d3:	eb 1c                	jmp    8030f1 <readn+0x73>
		if (m == 0)
  8030d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030d9:	75 02                	jne    8030dd <readn+0x5f>
			break;
  8030db:	eb 11                	jmp    8030ee <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8030e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e6:	48 98                	cltq   
  8030e8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030ec:	72 ac                	jb     80309a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8030ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030f1:	c9                   	leaveq 
  8030f2:	c3                   	retq   

00000000008030f3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8030f3:	55                   	push   %rbp
  8030f4:	48 89 e5             	mov    %rsp,%rbp
  8030f7:	48 83 ec 40          	sub    $0x40,%rsp
  8030fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803102:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803106:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80310a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80310d:	48 89 d6             	mov    %rdx,%rsi
  803110:	89 c7                	mov    %eax,%edi
  803112:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
  80311e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803121:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803125:	78 24                	js     80314b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312b:	8b 00                	mov    (%rax),%eax
  80312d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803131:	48 89 d6             	mov    %rdx,%rsi
  803134:	89 c7                	mov    %eax,%edi
  803136:	48 b8 d0 2c 80 00 00 	movabs $0x802cd0,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
  803142:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803145:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803149:	79 05                	jns    803150 <write+0x5d>
		return r;
  80314b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314e:	eb 75                	jmp    8031c5 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803150:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803154:	8b 40 08             	mov    0x8(%rax),%eax
  803157:	83 e0 03             	and    $0x3,%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	75 3a                	jne    803198 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80315e:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803165:	00 00 00 
  803168:	48 8b 00             	mov    (%rax),%rax
  80316b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803171:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803174:	89 c6                	mov    %eax,%esi
  803176:	48 bf 33 55 80 00 00 	movabs $0x805533,%rdi
  80317d:	00 00 00 
  803180:	b8 00 00 00 00       	mov    $0x0,%eax
  803185:	48 b9 79 08 80 00 00 	movabs $0x800879,%rcx
  80318c:	00 00 00 
  80318f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803191:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803196:	eb 2d                	jmp    8031c5 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319c:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031a0:	48 85 c0             	test   %rax,%rax
  8031a3:	75 07                	jne    8031ac <write+0xb9>
		return -E_NOT_SUPP;
  8031a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031aa:	eb 19                	jmp    8031c5 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8031ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031b4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031b8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031bc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8031c0:	48 89 cf             	mov    %rcx,%rdi
  8031c3:	ff d0                	callq  *%rax
}
  8031c5:	c9                   	leaveq 
  8031c6:	c3                   	retq   

00000000008031c7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8031c7:	55                   	push   %rbp
  8031c8:	48 89 e5             	mov    %rsp,%rbp
  8031cb:	48 83 ec 18          	sub    $0x18,%rsp
  8031cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031d2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031d5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031dc:	48 89 d6             	mov    %rdx,%rsi
  8031df:	89 c7                	mov    %eax,%edi
  8031e1:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
  8031ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f4:	79 05                	jns    8031fb <seek+0x34>
		return r;
  8031f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f9:	eb 0f                	jmp    80320a <seek+0x43>
	fd->fd_offset = offset;
  8031fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803202:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80320a:	c9                   	leaveq 
  80320b:	c3                   	retq   

000000000080320c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80320c:	55                   	push   %rbp
  80320d:	48 89 e5             	mov    %rsp,%rbp
  803210:	48 83 ec 30          	sub    $0x30,%rsp
  803214:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803217:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80321a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80321e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803221:	48 89 d6             	mov    %rdx,%rsi
  803224:	89 c7                	mov    %eax,%edi
  803226:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803235:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803239:	78 24                	js     80325f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80323b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323f:	8b 00                	mov    (%rax),%eax
  803241:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803245:	48 89 d6             	mov    %rdx,%rsi
  803248:	89 c7                	mov    %eax,%edi
  80324a:	48 b8 d0 2c 80 00 00 	movabs $0x802cd0,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
  803256:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803259:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80325d:	79 05                	jns    803264 <ftruncate+0x58>
		return r;
  80325f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803262:	eb 72                	jmp    8032d6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803268:	8b 40 08             	mov    0x8(%rax),%eax
  80326b:	83 e0 03             	and    $0x3,%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	75 3a                	jne    8032ac <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803272:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803279:	00 00 00 
  80327c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80327f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803285:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803288:	89 c6                	mov    %eax,%esi
  80328a:	48 bf 50 55 80 00 00 	movabs $0x805550,%rdi
  803291:	00 00 00 
  803294:	b8 00 00 00 00       	mov    $0x0,%eax
  803299:	48 b9 79 08 80 00 00 	movabs $0x800879,%rcx
  8032a0:	00 00 00 
  8032a3:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8032a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032aa:	eb 2a                	jmp    8032d6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8032ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032b4:	48 85 c0             	test   %rax,%rax
  8032b7:	75 07                	jne    8032c0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8032b9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032be:	eb 16                	jmp    8032d6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8032c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032cc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8032cf:	89 ce                	mov    %ecx,%esi
  8032d1:	48 89 d7             	mov    %rdx,%rdi
  8032d4:	ff d0                	callq  *%rax
}
  8032d6:	c9                   	leaveq 
  8032d7:	c3                   	retq   

00000000008032d8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8032d8:	55                   	push   %rbp
  8032d9:	48 89 e5             	mov    %rsp,%rbp
  8032dc:	48 83 ec 30          	sub    $0x30,%rsp
  8032e0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032e7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032ee:	48 89 d6             	mov    %rdx,%rsi
  8032f1:	89 c7                	mov    %eax,%edi
  8032f3:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
  8032ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803302:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803306:	78 24                	js     80332c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330c:	8b 00                	mov    (%rax),%eax
  80330e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803312:	48 89 d6             	mov    %rdx,%rsi
  803315:	89 c7                	mov    %eax,%edi
  803317:	48 b8 d0 2c 80 00 00 	movabs $0x802cd0,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
  803323:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803326:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332a:	79 05                	jns    803331 <fstat+0x59>
		return r;
  80332c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332f:	eb 5e                	jmp    80338f <fstat+0xb7>
	if (!dev->dev_stat)
  803331:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803335:	48 8b 40 28          	mov    0x28(%rax),%rax
  803339:	48 85 c0             	test   %rax,%rax
  80333c:	75 07                	jne    803345 <fstat+0x6d>
		return -E_NOT_SUPP;
  80333e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803343:	eb 4a                	jmp    80338f <fstat+0xb7>
	stat->st_name[0] = 0;
  803345:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803349:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80334c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803350:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803357:	00 00 00 
	stat->st_isdir = 0;
  80335a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803365:	00 00 00 
	stat->st_dev = dev;
  803368:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80336c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803370:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80337f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803383:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803387:	48 89 ce             	mov    %rcx,%rsi
  80338a:	48 89 d7             	mov    %rdx,%rdi
  80338d:	ff d0                	callq  *%rax
}
  80338f:	c9                   	leaveq 
  803390:	c3                   	retq   

0000000000803391 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803391:	55                   	push   %rbp
  803392:	48 89 e5             	mov    %rsp,%rbp
  803395:	48 83 ec 20          	sub    $0x20,%rsp
  803399:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80339d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8033a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a5:	be 00 00 00 00       	mov    $0x0,%esi
  8033aa:	48 89 c7             	mov    %rax,%rdi
  8033ad:	48 b8 7f 34 80 00 00 	movabs $0x80347f,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
  8033b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c0:	79 05                	jns    8033c7 <stat+0x36>
		return fd;
  8033c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c5:	eb 2f                	jmp    8033f6 <stat+0x65>
	r = fstat(fd, stat);
  8033c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ce:	48 89 d6             	mov    %rdx,%rsi
  8033d1:	89 c7                	mov    %eax,%edi
  8033d3:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
  8033df:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8033e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e5:	89 c7                	mov    %eax,%edi
  8033e7:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
	return r;
  8033f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8033f6:	c9                   	leaveq 
  8033f7:	c3                   	retq   

00000000008033f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033f8:	55                   	push   %rbp
  8033f9:	48 89 e5             	mov    %rsp,%rbp
  8033fc:	48 83 ec 10          	sub    $0x10,%rsp
  803400:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803403:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803407:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80340e:	00 00 00 
  803411:	8b 00                	mov    (%rax),%eax
  803413:	85 c0                	test   %eax,%eax
  803415:	75 1d                	jne    803434 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803417:	bf 01 00 00 00       	mov    $0x1,%edi
  80341c:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
  803428:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80342f:	00 00 00 
  803432:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803434:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80343b:	00 00 00 
  80343e:	8b 00                	mov    (%rax),%eax
  803440:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803443:	b9 07 00 00 00       	mov    $0x7,%ecx
  803448:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80344f:	00 00 00 
  803452:	89 c7                	mov    %eax,%edi
  803454:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803464:	ba 00 00 00 00       	mov    $0x0,%edx
  803469:	48 89 c6             	mov    %rax,%rsi
  80346c:	bf 00 00 00 00       	mov    $0x0,%edi
  803471:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  803478:	00 00 00 
  80347b:	ff d0                	callq  *%rax
}
  80347d:	c9                   	leaveq 
  80347e:	c3                   	retq   

000000000080347f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80347f:	55                   	push   %rbp
  803480:	48 89 e5             	mov    %rsp,%rbp
  803483:	48 83 ec 20          	sub    $0x20,%rsp
  803487:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80348b:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80348e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803492:	48 89 c7             	mov    %rax,%rdi
  803495:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
  8034a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034a6:	7e 0a                	jle    8034b2 <open+0x33>
		return -E_BAD_PATH;
  8034a8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034ad:	e9 a5 00 00 00       	jmpq   803557 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8034b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034b6:	48 89 c7             	mov    %rax,%rdi
  8034b9:	48 b8 df 2a 80 00 00 	movabs $0x802adf,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
  8034c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034cc:	79 08                	jns    8034d6 <open+0x57>
		return r;
  8034ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d1:	e9 81 00 00 00       	jmpq   803557 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8034d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034da:	48 89 c6             	mov    %rax,%rsi
  8034dd:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034e4:	00 00 00 
  8034e7:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8034f3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034fa:	00 00 00 
  8034fd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803500:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350a:	48 89 c6             	mov    %rax,%rsi
  80350d:	bf 01 00 00 00       	mov    $0x1,%edi
  803512:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  803519:	00 00 00 
  80351c:	ff d0                	callq  *%rax
  80351e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803521:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803525:	79 1d                	jns    803544 <open+0xc5>
		fd_close(fd, 0);
  803527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352b:	be 00 00 00 00       	mov    $0x0,%esi
  803530:	48 89 c7             	mov    %rax,%rdi
  803533:	48 b8 07 2c 80 00 00 	movabs $0x802c07,%rax
  80353a:	00 00 00 
  80353d:	ff d0                	callq  *%rax
		return r;
  80353f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803542:	eb 13                	jmp    803557 <open+0xd8>
	}

	return fd2num(fd);
  803544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803548:	48 89 c7             	mov    %rax,%rdi
  80354b:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax

}
  803557:	c9                   	leaveq 
  803558:	c3                   	retq   

0000000000803559 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803559:	55                   	push   %rbp
  80355a:	48 89 e5             	mov    %rsp,%rbp
  80355d:	48 83 ec 10          	sub    $0x10,%rsp
  803561:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803569:	8b 50 0c             	mov    0xc(%rax),%edx
  80356c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803573:	00 00 00 
  803576:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803578:	be 00 00 00 00       	mov    $0x0,%esi
  80357d:	bf 06 00 00 00       	mov    $0x6,%edi
  803582:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  803589:	00 00 00 
  80358c:	ff d0                	callq  *%rax
}
  80358e:	c9                   	leaveq 
  80358f:	c3                   	retq   

0000000000803590 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803590:	55                   	push   %rbp
  803591:	48 89 e5             	mov    %rsp,%rbp
  803594:	48 83 ec 30          	sub    $0x30,%rsp
  803598:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80359c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8035a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8035ab:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035b2:	00 00 00 
  8035b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8035b7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035be:	00 00 00 
  8035c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035c5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8035c9:	be 00 00 00 00       	mov    $0x0,%esi
  8035ce:	bf 03 00 00 00       	mov    $0x3,%edi
  8035d3:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  8035da:	00 00 00 
  8035dd:	ff d0                	callq  *%rax
  8035df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e6:	79 08                	jns    8035f0 <devfile_read+0x60>
		return r;
  8035e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035eb:	e9 a4 00 00 00       	jmpq   803694 <devfile_read+0x104>
	assert(r <= n);
  8035f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f3:	48 98                	cltq   
  8035f5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8035f9:	76 35                	jbe    803630 <devfile_read+0xa0>
  8035fb:	48 b9 76 55 80 00 00 	movabs $0x805576,%rcx
  803602:	00 00 00 
  803605:	48 ba 7d 55 80 00 00 	movabs $0x80557d,%rdx
  80360c:	00 00 00 
  80360f:	be 86 00 00 00       	mov    $0x86,%esi
  803614:	48 bf 92 55 80 00 00 	movabs $0x805592,%rdi
  80361b:	00 00 00 
  80361e:	b8 00 00 00 00       	mov    $0x0,%eax
  803623:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  80362a:	00 00 00 
  80362d:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803630:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803637:	7e 35                	jle    80366e <devfile_read+0xde>
  803639:	48 b9 9d 55 80 00 00 	movabs $0x80559d,%rcx
  803640:	00 00 00 
  803643:	48 ba 7d 55 80 00 00 	movabs $0x80557d,%rdx
  80364a:	00 00 00 
  80364d:	be 87 00 00 00       	mov    $0x87,%esi
  803652:	48 bf 92 55 80 00 00 	movabs $0x805592,%rdi
  803659:	00 00 00 
  80365c:	b8 00 00 00 00       	mov    $0x0,%eax
  803661:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  803668:	00 00 00 
  80366b:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80366e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803671:	48 63 d0             	movslq %eax,%rdx
  803674:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803678:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80367f:	00 00 00 
  803682:	48 89 c7             	mov    %rax,%rdi
  803685:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  80368c:	00 00 00 
  80368f:	ff d0                	callq  *%rax
	return r;
  803691:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 40          	sub    $0x40,%rsp
  80369e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036a6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8036aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036b2:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8036b9:	00 
  8036ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036be:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8036c2:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8036c7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8036cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036cf:	8b 50 0c             	mov    0xc(%rax),%edx
  8036d2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036d9:	00 00 00 
  8036dc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8036de:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036e5:	00 00 00 
  8036e8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036ec:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8036f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f8:	48 89 c6             	mov    %rax,%rsi
  8036fb:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803702:	00 00 00 
  803705:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  80370c:	00 00 00 
  80370f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803711:	be 00 00 00 00       	mov    $0x0,%esi
  803716:	bf 04 00 00 00       	mov    $0x4,%edi
  80371b:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
  803727:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80372a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80372e:	79 05                	jns    803735 <devfile_write+0x9f>
		return r;
  803730:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803733:	eb 43                	jmp    803778 <devfile_write+0xe2>
	assert(r <= n);
  803735:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803738:	48 98                	cltq   
  80373a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80373e:	76 35                	jbe    803775 <devfile_write+0xdf>
  803740:	48 b9 76 55 80 00 00 	movabs $0x805576,%rcx
  803747:	00 00 00 
  80374a:	48 ba 7d 55 80 00 00 	movabs $0x80557d,%rdx
  803751:	00 00 00 
  803754:	be a2 00 00 00       	mov    $0xa2,%esi
  803759:	48 bf 92 55 80 00 00 	movabs $0x805592,%rdi
  803760:	00 00 00 
  803763:	b8 00 00 00 00       	mov    $0x0,%eax
  803768:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  80376f:	00 00 00 
  803772:	41 ff d0             	callq  *%r8
	return r;
  803775:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803778:	c9                   	leaveq 
  803779:	c3                   	retq   

000000000080377a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80377a:	55                   	push   %rbp
  80377b:	48 89 e5             	mov    %rsp,%rbp
  80377e:	48 83 ec 20          	sub    $0x20,%rsp
  803782:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803786:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80378a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378e:	8b 50 0c             	mov    0xc(%rax),%edx
  803791:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803798:	00 00 00 
  80379b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80379d:	be 00 00 00 00       	mov    $0x0,%esi
  8037a2:	bf 05 00 00 00       	mov    $0x5,%edi
  8037a7:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  8037ae:	00 00 00 
  8037b1:	ff d0                	callq  *%rax
  8037b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ba:	79 05                	jns    8037c1 <devfile_stat+0x47>
		return r;
  8037bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bf:	eb 56                	jmp    803817 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8037c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c5:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8037cc:	00 00 00 
  8037cf:	48 89 c7             	mov    %rax,%rdi
  8037d2:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8037de:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037e5:	00 00 00 
  8037e8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8037ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037f2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8037f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037ff:	00 00 00 
  803802:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803808:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80380c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803817:	c9                   	leaveq 
  803818:	c3                   	retq   

0000000000803819 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803819:	55                   	push   %rbp
  80381a:	48 89 e5             	mov    %rsp,%rbp
  80381d:	48 83 ec 10          	sub    $0x10,%rsp
  803821:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803825:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382c:	8b 50 0c             	mov    0xc(%rax),%edx
  80382f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803836:	00 00 00 
  803839:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80383b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803842:	00 00 00 
  803845:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803848:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80384b:	be 00 00 00 00       	mov    $0x0,%esi
  803850:	bf 02 00 00 00       	mov    $0x2,%edi
  803855:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  80385c:	00 00 00 
  80385f:	ff d0                	callq  *%rax
}
  803861:	c9                   	leaveq 
  803862:	c3                   	retq   

0000000000803863 <remove>:

// Delete a file
int
remove(const char *path)
{
  803863:	55                   	push   %rbp
  803864:	48 89 e5             	mov    %rsp,%rbp
  803867:	48 83 ec 10          	sub    $0x10,%rsp
  80386b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80386f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803873:	48 89 c7             	mov    %rax,%rdi
  803876:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  80387d:	00 00 00 
  803880:	ff d0                	callq  *%rax
  803882:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803887:	7e 07                	jle    803890 <remove+0x2d>
		return -E_BAD_PATH;
  803889:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80388e:	eb 33                	jmp    8038c3 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803890:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803894:	48 89 c6             	mov    %rax,%rsi
  803897:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80389e:	00 00 00 
  8038a1:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8038ad:	be 00 00 00 00       	mov    $0x0,%esi
  8038b2:	bf 07 00 00 00       	mov    $0x7,%edi
  8038b7:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  8038be:	00 00 00 
  8038c1:	ff d0                	callq  *%rax
}
  8038c3:	c9                   	leaveq 
  8038c4:	c3                   	retq   

00000000008038c5 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8038c5:	55                   	push   %rbp
  8038c6:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8038c9:	be 00 00 00 00       	mov    $0x0,%esi
  8038ce:	bf 08 00 00 00       	mov    $0x8,%edi
  8038d3:	48 b8 f8 33 80 00 00 	movabs $0x8033f8,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
}
  8038df:	5d                   	pop    %rbp
  8038e0:	c3                   	retq   

00000000008038e1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8038e1:	55                   	push   %rbp
  8038e2:	48 89 e5             	mov    %rsp,%rbp
  8038e5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8038ec:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8038f3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8038fa:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803901:	be 00 00 00 00       	mov    $0x0,%esi
  803906:	48 89 c7             	mov    %rax,%rdi
  803909:	48 b8 7f 34 80 00 00 	movabs $0x80347f,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
  803915:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803918:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391c:	79 28                	jns    803946 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80391e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803921:	89 c6                	mov    %eax,%esi
  803923:	48 bf a9 55 80 00 00 	movabs $0x8055a9,%rdi
  80392a:	00 00 00 
  80392d:	b8 00 00 00 00       	mov    $0x0,%eax
  803932:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  803939:	00 00 00 
  80393c:	ff d2                	callq  *%rdx
		return fd_src;
  80393e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803941:	e9 74 01 00 00       	jmpq   803aba <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803946:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80394d:	be 01 01 00 00       	mov    $0x101,%esi
  803952:	48 89 c7             	mov    %rax,%rdi
  803955:	48 b8 7f 34 80 00 00 	movabs $0x80347f,%rax
  80395c:	00 00 00 
  80395f:	ff d0                	callq  *%rax
  803961:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803964:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803968:	79 39                	jns    8039a3 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80396a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80396d:	89 c6                	mov    %eax,%esi
  80396f:	48 bf bf 55 80 00 00 	movabs $0x8055bf,%rdi
  803976:	00 00 00 
  803979:	b8 00 00 00 00       	mov    $0x0,%eax
  80397e:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  803985:	00 00 00 
  803988:	ff d2                	callq  *%rdx
		close(fd_src);
  80398a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398d:	89 c7                	mov    %eax,%edi
  80398f:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  803996:	00 00 00 
  803999:	ff d0                	callq  *%rax
		return fd_dest;
  80399b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399e:	e9 17 01 00 00       	jmpq   803aba <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8039a3:	eb 74                	jmp    803a19 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8039a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039a8:	48 63 d0             	movslq %eax,%rdx
  8039ab:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8039b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039b5:	48 89 ce             	mov    %rcx,%rsi
  8039b8:	89 c7                	mov    %eax,%edi
  8039ba:	48 b8 f3 30 80 00 00 	movabs $0x8030f3,%rax
  8039c1:	00 00 00 
  8039c4:	ff d0                	callq  *%rax
  8039c6:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8039c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8039cd:	79 4a                	jns    803a19 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8039cf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8039d2:	89 c6                	mov    %eax,%esi
  8039d4:	48 bf d9 55 80 00 00 	movabs $0x8055d9,%rdi
  8039db:	00 00 00 
  8039de:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e3:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  8039ea:	00 00 00 
  8039ed:	ff d2                	callq  *%rdx
			close(fd_src);
  8039ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f2:	89 c7                	mov    %eax,%edi
  8039f4:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
			close(fd_dest);
  803a00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a03:	89 c7                	mov    %eax,%edi
  803a05:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  803a0c:	00 00 00 
  803a0f:	ff d0                	callq  *%rax
			return write_size;
  803a11:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a14:	e9 a1 00 00 00       	jmpq   803aba <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803a19:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a23:	ba 00 02 00 00       	mov    $0x200,%edx
  803a28:	48 89 ce             	mov    %rcx,%rsi
  803a2b:	89 c7                	mov    %eax,%edi
  803a2d:	48 b8 a9 2f 80 00 00 	movabs $0x802fa9,%rax
  803a34:	00 00 00 
  803a37:	ff d0                	callq  *%rax
  803a39:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803a3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a40:	0f 8f 5f ff ff ff    	jg     8039a5 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803a46:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a4a:	79 47                	jns    803a93 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803a4c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a4f:	89 c6                	mov    %eax,%esi
  803a51:	48 bf ec 55 80 00 00 	movabs $0x8055ec,%rdi
  803a58:	00 00 00 
  803a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a60:	48 ba 79 08 80 00 00 	movabs $0x800879,%rdx
  803a67:	00 00 00 
  803a6a:	ff d2                	callq  *%rdx
		close(fd_src);
  803a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6f:	89 c7                	mov    %eax,%edi
  803a71:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  803a78:	00 00 00 
  803a7b:	ff d0                	callq  *%rax
		close(fd_dest);
  803a7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a80:	89 c7                	mov    %eax,%edi
  803a82:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
		return read_size;
  803a8e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a91:	eb 27                	jmp    803aba <copy+0x1d9>
	}
	close(fd_src);
  803a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a96:	89 c7                	mov    %eax,%edi
  803a98:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  803a9f:	00 00 00 
  803aa2:	ff d0                	callq  *%rax
	close(fd_dest);
  803aa4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aa7:	89 c7                	mov    %eax,%edi
  803aa9:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
	return 0;
  803ab5:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803aba:	c9                   	leaveq 
  803abb:	c3                   	retq   

0000000000803abc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803abc:	55                   	push   %rbp
  803abd:	48 89 e5             	mov    %rsp,%rbp
  803ac0:	48 83 ec 20          	sub    $0x20,%rsp
  803ac4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803ac7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803acb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ace:	48 89 d6             	mov    %rdx,%rsi
  803ad1:	89 c7                	mov    %eax,%edi
  803ad3:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
  803adf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae6:	79 05                	jns    803aed <fd2sockid+0x31>
		return r;
  803ae8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aeb:	eb 24                	jmp    803b11 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af1:	8b 10                	mov    (%rax),%edx
  803af3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803afa:	00 00 00 
  803afd:	8b 00                	mov    (%rax),%eax
  803aff:	39 c2                	cmp    %eax,%edx
  803b01:	74 07                	je     803b0a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803b03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803b08:	eb 07                	jmp    803b11 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803b11:	c9                   	leaveq 
  803b12:	c3                   	retq   

0000000000803b13 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803b13:	55                   	push   %rbp
  803b14:	48 89 e5             	mov    %rsp,%rbp
  803b17:	48 83 ec 20          	sub    $0x20,%rsp
  803b1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803b1e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b22:	48 89 c7             	mov    %rax,%rdi
  803b25:	48 b8 df 2a 80 00 00 	movabs $0x802adf,%rax
  803b2c:	00 00 00 
  803b2f:	ff d0                	callq  *%rax
  803b31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b38:	78 26                	js     803b60 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803b3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3e:	ba 07 04 00 00       	mov    $0x407,%edx
  803b43:	48 89 c6             	mov    %rax,%rsi
  803b46:	bf 00 00 00 00       	mov    $0x0,%edi
  803b4b:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  803b52:	00 00 00 
  803b55:	ff d0                	callq  *%rax
  803b57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b5e:	79 16                	jns    803b76 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803b60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b63:	89 c7                	mov    %eax,%edi
  803b65:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  803b6c:	00 00 00 
  803b6f:	ff d0                	callq  *%rax
		return r;
  803b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b74:	eb 3a                	jmp    803bb0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803b81:	00 00 00 
  803b84:	8b 12                	mov    (%rdx),%edx
  803b86:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803b88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b97:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b9a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba1:	48 89 c7             	mov    %rax,%rdi
  803ba4:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  803bab:	00 00 00 
  803bae:	ff d0                	callq  *%rax
}
  803bb0:	c9                   	leaveq 
  803bb1:	c3                   	retq   

0000000000803bb2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803bb2:	55                   	push   %rbp
  803bb3:	48 89 e5             	mov    %rsp,%rbp
  803bb6:	48 83 ec 30          	sub    $0x30,%rsp
  803bba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bbd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bc1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bc5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc8:	89 c7                	mov    %eax,%edi
  803bca:	48 b8 bc 3a 80 00 00 	movabs $0x803abc,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
  803bd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bdd:	79 05                	jns    803be4 <accept+0x32>
		return r;
  803bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be2:	eb 3b                	jmp    803c1f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803be4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803be8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bef:	48 89 ce             	mov    %rcx,%rsi
  803bf2:	89 c7                	mov    %eax,%edi
  803bf4:	48 b8 fd 3e 80 00 00 	movabs $0x803efd,%rax
  803bfb:	00 00 00 
  803bfe:	ff d0                	callq  *%rax
  803c00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c07:	79 05                	jns    803c0e <accept+0x5c>
		return r;
  803c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0c:	eb 11                	jmp    803c1f <accept+0x6d>
	return alloc_sockfd(r);
  803c0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c11:	89 c7                	mov    %eax,%edi
  803c13:	48 b8 13 3b 80 00 00 	movabs $0x803b13,%rax
  803c1a:	00 00 00 
  803c1d:	ff d0                	callq  *%rax
}
  803c1f:	c9                   	leaveq 
  803c20:	c3                   	retq   

0000000000803c21 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c21:	55                   	push   %rbp
  803c22:	48 89 e5             	mov    %rsp,%rbp
  803c25:	48 83 ec 20          	sub    $0x20,%rsp
  803c29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c30:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c36:	89 c7                	mov    %eax,%edi
  803c38:	48 b8 bc 3a 80 00 00 	movabs $0x803abc,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
  803c44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c4b:	79 05                	jns    803c52 <bind+0x31>
		return r;
  803c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c50:	eb 1b                	jmp    803c6d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803c52:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c55:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c5c:	48 89 ce             	mov    %rcx,%rsi
  803c5f:	89 c7                	mov    %eax,%edi
  803c61:	48 b8 7c 3f 80 00 00 	movabs $0x803f7c,%rax
  803c68:	00 00 00 
  803c6b:	ff d0                	callq  *%rax
}
  803c6d:	c9                   	leaveq 
  803c6e:	c3                   	retq   

0000000000803c6f <shutdown>:

int
shutdown(int s, int how)
{
  803c6f:	55                   	push   %rbp
  803c70:	48 89 e5             	mov    %rsp,%rbp
  803c73:	48 83 ec 20          	sub    $0x20,%rsp
  803c77:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c7a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c80:	89 c7                	mov    %eax,%edi
  803c82:	48 b8 bc 3a 80 00 00 	movabs $0x803abc,%rax
  803c89:	00 00 00 
  803c8c:	ff d0                	callq  *%rax
  803c8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c95:	79 05                	jns    803c9c <shutdown+0x2d>
		return r;
  803c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c9a:	eb 16                	jmp    803cb2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803c9c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca2:	89 d6                	mov    %edx,%esi
  803ca4:	89 c7                	mov    %eax,%edi
  803ca6:	48 b8 e0 3f 80 00 00 	movabs $0x803fe0,%rax
  803cad:	00 00 00 
  803cb0:	ff d0                	callq  *%rax
}
  803cb2:	c9                   	leaveq 
  803cb3:	c3                   	retq   

0000000000803cb4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803cb4:	55                   	push   %rbp
  803cb5:	48 89 e5             	mov    %rsp,%rbp
  803cb8:	48 83 ec 10          	sub    $0x10,%rsp
  803cbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc4:	48 89 c7             	mov    %rax,%rdi
  803cc7:	48 b8 6c 4c 80 00 00 	movabs $0x804c6c,%rax
  803cce:	00 00 00 
  803cd1:	ff d0                	callq  *%rax
  803cd3:	83 f8 01             	cmp    $0x1,%eax
  803cd6:	75 17                	jne    803cef <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cdc:	8b 40 0c             	mov    0xc(%rax),%eax
  803cdf:	89 c7                	mov    %eax,%edi
  803ce1:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  803ce8:	00 00 00 
  803ceb:	ff d0                	callq  *%rax
  803ced:	eb 05                	jmp    803cf4 <devsock_close+0x40>
	else
		return 0;
  803cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cf4:	c9                   	leaveq 
  803cf5:	c3                   	retq   

0000000000803cf6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803cf6:	55                   	push   %rbp
  803cf7:	48 89 e5             	mov    %rsp,%rbp
  803cfa:	48 83 ec 20          	sub    $0x20,%rsp
  803cfe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d05:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d0b:	89 c7                	mov    %eax,%edi
  803d0d:	48 b8 bc 3a 80 00 00 	movabs $0x803abc,%rax
  803d14:	00 00 00 
  803d17:	ff d0                	callq  *%rax
  803d19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d20:	79 05                	jns    803d27 <connect+0x31>
		return r;
  803d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d25:	eb 1b                	jmp    803d42 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803d27:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d2a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d31:	48 89 ce             	mov    %rcx,%rsi
  803d34:	89 c7                	mov    %eax,%edi
  803d36:	48 b8 4d 40 80 00 00 	movabs $0x80404d,%rax
  803d3d:	00 00 00 
  803d40:	ff d0                	callq  *%rax
}
  803d42:	c9                   	leaveq 
  803d43:	c3                   	retq   

0000000000803d44 <listen>:

int
listen(int s, int backlog)
{
  803d44:	55                   	push   %rbp
  803d45:	48 89 e5             	mov    %rsp,%rbp
  803d48:	48 83 ec 20          	sub    $0x20,%rsp
  803d4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d4f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d55:	89 c7                	mov    %eax,%edi
  803d57:	48 b8 bc 3a 80 00 00 	movabs $0x803abc,%rax
  803d5e:	00 00 00 
  803d61:	ff d0                	callq  *%rax
  803d63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6a:	79 05                	jns    803d71 <listen+0x2d>
		return r;
  803d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6f:	eb 16                	jmp    803d87 <listen+0x43>
	return nsipc_listen(r, backlog);
  803d71:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d77:	89 d6                	mov    %edx,%esi
  803d79:	89 c7                	mov    %eax,%edi
  803d7b:	48 b8 b1 40 80 00 00 	movabs $0x8040b1,%rax
  803d82:	00 00 00 
  803d85:	ff d0                	callq  *%rax
}
  803d87:	c9                   	leaveq 
  803d88:	c3                   	retq   

0000000000803d89 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803d89:	55                   	push   %rbp
  803d8a:	48 89 e5             	mov    %rsp,%rbp
  803d8d:	48 83 ec 20          	sub    $0x20,%rsp
  803d91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d99:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803d9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803da1:	89 c2                	mov    %eax,%edx
  803da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da7:	8b 40 0c             	mov    0xc(%rax),%eax
  803daa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803dae:	b9 00 00 00 00       	mov    $0x0,%ecx
  803db3:	89 c7                	mov    %eax,%edi
  803db5:	48 b8 f1 40 80 00 00 	movabs $0x8040f1,%rax
  803dbc:	00 00 00 
  803dbf:	ff d0                	callq  *%rax
}
  803dc1:	c9                   	leaveq 
  803dc2:	c3                   	retq   

0000000000803dc3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803dc3:	55                   	push   %rbp
  803dc4:	48 89 e5             	mov    %rsp,%rbp
  803dc7:	48 83 ec 20          	sub    $0x20,%rsp
  803dcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803dd3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ddb:	89 c2                	mov    %eax,%edx
  803ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de1:	8b 40 0c             	mov    0xc(%rax),%eax
  803de4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803de8:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ded:	89 c7                	mov    %eax,%edi
  803def:	48 b8 bd 41 80 00 00 	movabs $0x8041bd,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	48 83 ec 10          	sub    $0x10,%rsp
  803e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e11:	48 be 07 56 80 00 00 	movabs $0x805607,%rsi
  803e18:	00 00 00 
  803e1b:	48 89 c7             	mov    %rax,%rdi
  803e1e:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
	return 0;
  803e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e2f:	c9                   	leaveq 
  803e30:	c3                   	retq   

0000000000803e31 <socket>:

int
socket(int domain, int type, int protocol)
{
  803e31:	55                   	push   %rbp
  803e32:	48 89 e5             	mov    %rsp,%rbp
  803e35:	48 83 ec 20          	sub    $0x20,%rsp
  803e39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e3c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e3f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803e42:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803e45:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e4b:	89 ce                	mov    %ecx,%esi
  803e4d:	89 c7                	mov    %eax,%edi
  803e4f:	48 b8 75 42 80 00 00 	movabs $0x804275,%rax
  803e56:	00 00 00 
  803e59:	ff d0                	callq  *%rax
  803e5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e62:	79 05                	jns    803e69 <socket+0x38>
		return r;
  803e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e67:	eb 11                	jmp    803e7a <socket+0x49>
	return alloc_sockfd(r);
  803e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e6c:	89 c7                	mov    %eax,%edi
  803e6e:	48 b8 13 3b 80 00 00 	movabs $0x803b13,%rax
  803e75:	00 00 00 
  803e78:	ff d0                	callq  *%rax
}
  803e7a:	c9                   	leaveq 
  803e7b:	c3                   	retq   

0000000000803e7c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803e7c:	55                   	push   %rbp
  803e7d:	48 89 e5             	mov    %rsp,%rbp
  803e80:	48 83 ec 10          	sub    $0x10,%rsp
  803e84:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803e87:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e8e:	00 00 00 
  803e91:	8b 00                	mov    (%rax),%eax
  803e93:	85 c0                	test   %eax,%eax
  803e95:	75 1d                	jne    803eb4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803e97:	bf 02 00 00 00       	mov    $0x2,%edi
  803e9c:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  803ea3:	00 00 00 
  803ea6:	ff d0                	callq  *%rax
  803ea8:	48 ba 08 80 80 00 00 	movabs $0x808008,%rdx
  803eaf:	00 00 00 
  803eb2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803eb4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ebb:	00 00 00 
  803ebe:	8b 00                	mov    (%rax),%eax
  803ec0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ec3:	b9 07 00 00 00       	mov    $0x7,%ecx
  803ec8:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803ecf:	00 00 00 
  803ed2:	89 c7                	mov    %eax,%edi
  803ed4:	48 b8 13 28 80 00 00 	movabs $0x802813,%rax
  803edb:	00 00 00 
  803ede:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  803ee5:	be 00 00 00 00       	mov    $0x0,%esi
  803eea:	bf 00 00 00 00       	mov    $0x0,%edi
  803eef:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  803ef6:	00 00 00 
  803ef9:	ff d0                	callq  *%rax
}
  803efb:	c9                   	leaveq 
  803efc:	c3                   	retq   

0000000000803efd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803efd:	55                   	push   %rbp
  803efe:	48 89 e5             	mov    %rsp,%rbp
  803f01:	48 83 ec 30          	sub    $0x30,%rsp
  803f05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803f10:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f17:	00 00 00 
  803f1a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f1d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803f1f:	bf 01 00 00 00       	mov    $0x1,%edi
  803f24:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  803f2b:	00 00 00 
  803f2e:	ff d0                	callq  *%rax
  803f30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f37:	78 3e                	js     803f77 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803f39:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f40:	00 00 00 
  803f43:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f4b:	8b 40 10             	mov    0x10(%rax),%eax
  803f4e:	89 c2                	mov    %eax,%edx
  803f50:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803f54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f58:	48 89 ce             	mov    %rcx,%rsi
  803f5b:	48 89 c7             	mov    %rax,%rdi
  803f5e:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  803f65:	00 00 00 
  803f68:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f6e:	8b 50 10             	mov    0x10(%rax),%edx
  803f71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f75:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f7a:	c9                   	leaveq 
  803f7b:	c3                   	retq   

0000000000803f7c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f7c:	55                   	push   %rbp
  803f7d:	48 89 e5             	mov    %rsp,%rbp
  803f80:	48 83 ec 10          	sub    $0x10,%rsp
  803f84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f8b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803f8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f95:	00 00 00 
  803f98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f9b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803f9d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa4:	48 89 c6             	mov    %rax,%rsi
  803fa7:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803fae:	00 00 00 
  803fb1:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  803fb8:	00 00 00 
  803fbb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803fbd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fc4:	00 00 00 
  803fc7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fca:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803fcd:	bf 02 00 00 00       	mov    $0x2,%edi
  803fd2:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  803fd9:	00 00 00 
  803fdc:	ff d0                	callq  *%rax
}
  803fde:	c9                   	leaveq 
  803fdf:	c3                   	retq   

0000000000803fe0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803fe0:	55                   	push   %rbp
  803fe1:	48 89 e5             	mov    %rsp,%rbp
  803fe4:	48 83 ec 10          	sub    $0x10,%rsp
  803fe8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803feb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803fee:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ff5:	00 00 00 
  803ff8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ffb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ffd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804004:	00 00 00 
  804007:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80400a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80400d:	bf 03 00 00 00       	mov    $0x3,%edi
  804012:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  804019:	00 00 00 
  80401c:	ff d0                	callq  *%rax
}
  80401e:	c9                   	leaveq 
  80401f:	c3                   	retq   

0000000000804020 <nsipc_close>:

int
nsipc_close(int s)
{
  804020:	55                   	push   %rbp
  804021:	48 89 e5             	mov    %rsp,%rbp
  804024:	48 83 ec 10          	sub    $0x10,%rsp
  804028:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80402b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804032:	00 00 00 
  804035:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804038:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80403a:	bf 04 00 00 00       	mov    $0x4,%edi
  80403f:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  804046:	00 00 00 
  804049:	ff d0                	callq  *%rax
}
  80404b:	c9                   	leaveq 
  80404c:	c3                   	retq   

000000000080404d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80404d:	55                   	push   %rbp
  80404e:	48 89 e5             	mov    %rsp,%rbp
  804051:	48 83 ec 10          	sub    $0x10,%rsp
  804055:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804058:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80405c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80405f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804066:	00 00 00 
  804069:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80406c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80406e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804075:	48 89 c6             	mov    %rax,%rsi
  804078:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80407f:	00 00 00 
  804082:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80408e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804095:	00 00 00 
  804098:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80409b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80409e:	bf 05 00 00 00       	mov    $0x5,%edi
  8040a3:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
}
  8040af:	c9                   	leaveq 
  8040b0:	c3                   	retq   

00000000008040b1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8040b1:	55                   	push   %rbp
  8040b2:	48 89 e5             	mov    %rsp,%rbp
  8040b5:	48 83 ec 10          	sub    $0x10,%rsp
  8040b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040bc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8040bf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040c6:	00 00 00 
  8040c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040cc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8040ce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040d5:	00 00 00 
  8040d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040db:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8040de:	bf 06 00 00 00       	mov    $0x6,%edi
  8040e3:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  8040ea:	00 00 00 
  8040ed:	ff d0                	callq  *%rax
}
  8040ef:	c9                   	leaveq 
  8040f0:	c3                   	retq   

00000000008040f1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8040f1:	55                   	push   %rbp
  8040f2:	48 89 e5             	mov    %rsp,%rbp
  8040f5:	48 83 ec 30          	sub    $0x30,%rsp
  8040f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804100:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804103:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804106:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80410d:	00 00 00 
  804110:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804113:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804115:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80411c:	00 00 00 
  80411f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804122:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804125:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80412c:	00 00 00 
  80412f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804132:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804135:	bf 07 00 00 00       	mov    $0x7,%edi
  80413a:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  804141:	00 00 00 
  804144:	ff d0                	callq  *%rax
  804146:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80414d:	78 69                	js     8041b8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80414f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804156:	7f 08                	jg     804160 <nsipc_recv+0x6f>
  804158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80415e:	7e 35                	jle    804195 <nsipc_recv+0xa4>
  804160:	48 b9 0e 56 80 00 00 	movabs $0x80560e,%rcx
  804167:	00 00 00 
  80416a:	48 ba 23 56 80 00 00 	movabs $0x805623,%rdx
  804171:	00 00 00 
  804174:	be 62 00 00 00       	mov    $0x62,%esi
  804179:	48 bf 38 56 80 00 00 	movabs $0x805638,%rdi
  804180:	00 00 00 
  804183:	b8 00 00 00 00       	mov    $0x0,%eax
  804188:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  80418f:	00 00 00 
  804192:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804198:	48 63 d0             	movslq %eax,%rdx
  80419b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80419f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8041a6:	00 00 00 
  8041a9:	48 89 c7             	mov    %rax,%rdi
  8041ac:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  8041b3:	00 00 00 
  8041b6:	ff d0                	callq  *%rax
	}

	return r;
  8041b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041bb:	c9                   	leaveq 
  8041bc:	c3                   	retq   

00000000008041bd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8041bd:	55                   	push   %rbp
  8041be:	48 89 e5             	mov    %rsp,%rbp
  8041c1:	48 83 ec 20          	sub    $0x20,%rsp
  8041c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8041cf:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8041d2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041d9:	00 00 00 
  8041dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041df:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8041e1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8041e8:	7e 35                	jle    80421f <nsipc_send+0x62>
  8041ea:	48 b9 44 56 80 00 00 	movabs $0x805644,%rcx
  8041f1:	00 00 00 
  8041f4:	48 ba 23 56 80 00 00 	movabs $0x805623,%rdx
  8041fb:	00 00 00 
  8041fe:	be 6d 00 00 00       	mov    $0x6d,%esi
  804203:	48 bf 38 56 80 00 00 	movabs $0x805638,%rdi
  80420a:	00 00 00 
  80420d:	b8 00 00 00 00       	mov    $0x0,%eax
  804212:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  804219:	00 00 00 
  80421c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80421f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804222:	48 63 d0             	movslq %eax,%rdx
  804225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804229:	48 89 c6             	mov    %rax,%rsi
  80422c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804233:	00 00 00 
  804236:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  80423d:	00 00 00 
  804240:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804242:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804249:	00 00 00 
  80424c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80424f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804252:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804259:	00 00 00 
  80425c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80425f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804262:	bf 08 00 00 00       	mov    $0x8,%edi
  804267:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  80426e:	00 00 00 
  804271:	ff d0                	callq  *%rax
}
  804273:	c9                   	leaveq 
  804274:	c3                   	retq   

0000000000804275 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804275:	55                   	push   %rbp
  804276:	48 89 e5             	mov    %rsp,%rbp
  804279:	48 83 ec 10          	sub    $0x10,%rsp
  80427d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804280:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804283:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804286:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80428d:	00 00 00 
  804290:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804293:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804295:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80429c:	00 00 00 
  80429f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042a2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8042a5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042ac:	00 00 00 
  8042af:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8042b2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8042b5:	bf 09 00 00 00       	mov    $0x9,%edi
  8042ba:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  8042c1:	00 00 00 
  8042c4:	ff d0                	callq  *%rax
}
  8042c6:	c9                   	leaveq 
  8042c7:	c3                   	retq   

00000000008042c8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8042c8:	55                   	push   %rbp
  8042c9:	48 89 e5             	mov    %rsp,%rbp
  8042cc:	53                   	push   %rbx
  8042cd:	48 83 ec 38          	sub    $0x38,%rsp
  8042d1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8042d5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8042d9:	48 89 c7             	mov    %rax,%rdi
  8042dc:	48 b8 df 2a 80 00 00 	movabs $0x802adf,%rax
  8042e3:	00 00 00 
  8042e6:	ff d0                	callq  *%rax
  8042e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042ef:	0f 88 bf 01 00 00    	js     8044b4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f9:	ba 07 04 00 00       	mov    $0x407,%edx
  8042fe:	48 89 c6             	mov    %rax,%rsi
  804301:	bf 00 00 00 00       	mov    $0x0,%edi
  804306:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  80430d:	00 00 00 
  804310:	ff d0                	callq  *%rax
  804312:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804315:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804319:	0f 88 95 01 00 00    	js     8044b4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80431f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804323:	48 89 c7             	mov    %rax,%rdi
  804326:	48 b8 df 2a 80 00 00 	movabs $0x802adf,%rax
  80432d:	00 00 00 
  804330:	ff d0                	callq  *%rax
  804332:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804335:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804339:	0f 88 5d 01 00 00    	js     80449c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80433f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804343:	ba 07 04 00 00       	mov    $0x407,%edx
  804348:	48 89 c6             	mov    %rax,%rsi
  80434b:	bf 00 00 00 00       	mov    $0x0,%edi
  804350:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  804357:	00 00 00 
  80435a:	ff d0                	callq  *%rax
  80435c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80435f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804363:	0f 88 33 01 00 00    	js     80449c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804369:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80436d:	48 89 c7             	mov    %rax,%rdi
  804370:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  804377:	00 00 00 
  80437a:	ff d0                	callq  *%rax
  80437c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804380:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804384:	ba 07 04 00 00       	mov    $0x407,%edx
  804389:	48 89 c6             	mov    %rax,%rsi
  80438c:	bf 00 00 00 00       	mov    $0x0,%edi
  804391:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  804398:	00 00 00 
  80439b:	ff d0                	callq  *%rax
  80439d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043a4:	79 05                	jns    8043ab <pipe+0xe3>
		goto err2;
  8043a6:	e9 d9 00 00 00       	jmpq   804484 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043af:	48 89 c7             	mov    %rax,%rdi
  8043b2:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8043b9:	00 00 00 
  8043bc:	ff d0                	callq  *%rax
  8043be:	48 89 c2             	mov    %rax,%rdx
  8043c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043c5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8043cb:	48 89 d1             	mov    %rdx,%rcx
  8043ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8043d3:	48 89 c6             	mov    %rax,%rsi
  8043d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8043db:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  8043e2:	00 00 00 
  8043e5:	ff d0                	callq  *%rax
  8043e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043ee:	79 1b                	jns    80440b <pipe+0x143>
		goto err3;
  8043f0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8043f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043f5:	48 89 c6             	mov    %rax,%rsi
  8043f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8043fd:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  804404:	00 00 00 
  804407:	ff d0                	callq  *%rax
  804409:	eb 79                	jmp    804484 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80440b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804416:	00 00 00 
  804419:	8b 12                	mov    (%rdx),%edx
  80441b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80441d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804421:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804428:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80442c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804433:	00 00 00 
  804436:	8b 12                	mov    (%rdx),%edx
  804438:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80443a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80443e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804449:	48 89 c7             	mov    %rax,%rdi
  80444c:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  804453:	00 00 00 
  804456:	ff d0                	callq  *%rax
  804458:	89 c2                	mov    %eax,%edx
  80445a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80445e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804460:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804464:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804468:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80446c:	48 89 c7             	mov    %rax,%rdi
  80446f:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
  80447b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80447d:	b8 00 00 00 00       	mov    $0x0,%eax
  804482:	eb 33                	jmp    8044b7 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804484:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804488:	48 89 c6             	mov    %rax,%rsi
  80448b:	bf 00 00 00 00       	mov    $0x0,%edi
  804490:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  804497:	00 00 00 
  80449a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80449c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044a0:	48 89 c6             	mov    %rax,%rsi
  8044a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8044a8:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  8044af:	00 00 00 
  8044b2:	ff d0                	callq  *%rax
err:
	return r;
  8044b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8044b7:	48 83 c4 38          	add    $0x38,%rsp
  8044bb:	5b                   	pop    %rbx
  8044bc:	5d                   	pop    %rbp
  8044bd:	c3                   	retq   

00000000008044be <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8044be:	55                   	push   %rbp
  8044bf:	48 89 e5             	mov    %rsp,%rbp
  8044c2:	53                   	push   %rbx
  8044c3:	48 83 ec 28          	sub    $0x28,%rsp
  8044c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8044cf:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8044d6:	00 00 00 
  8044d9:	48 8b 00             	mov    (%rax),%rax
  8044dc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8044e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044e9:	48 89 c7             	mov    %rax,%rdi
  8044ec:	48 b8 6c 4c 80 00 00 	movabs $0x804c6c,%rax
  8044f3:	00 00 00 
  8044f6:	ff d0                	callq  *%rax
  8044f8:	89 c3                	mov    %eax,%ebx
  8044fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044fe:	48 89 c7             	mov    %rax,%rdi
  804501:	48 b8 6c 4c 80 00 00 	movabs $0x804c6c,%rax
  804508:	00 00 00 
  80450b:	ff d0                	callq  *%rax
  80450d:	39 c3                	cmp    %eax,%ebx
  80450f:	0f 94 c0             	sete   %al
  804512:	0f b6 c0             	movzbl %al,%eax
  804515:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804518:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80451f:	00 00 00 
  804522:	48 8b 00             	mov    (%rax),%rax
  804525:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80452b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80452e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804531:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804534:	75 05                	jne    80453b <_pipeisclosed+0x7d>
			return ret;
  804536:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804539:	eb 4f                	jmp    80458a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80453b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80453e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804541:	74 42                	je     804585 <_pipeisclosed+0xc7>
  804543:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804547:	75 3c                	jne    804585 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804549:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804550:	00 00 00 
  804553:	48 8b 00             	mov    (%rax),%rax
  804556:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80455c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80455f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804562:	89 c6                	mov    %eax,%esi
  804564:	48 bf 55 56 80 00 00 	movabs $0x805655,%rdi
  80456b:	00 00 00 
  80456e:	b8 00 00 00 00       	mov    $0x0,%eax
  804573:	49 b8 79 08 80 00 00 	movabs $0x800879,%r8
  80457a:	00 00 00 
  80457d:	41 ff d0             	callq  *%r8
	}
  804580:	e9 4a ff ff ff       	jmpq   8044cf <_pipeisclosed+0x11>
  804585:	e9 45 ff ff ff       	jmpq   8044cf <_pipeisclosed+0x11>

}
  80458a:	48 83 c4 28          	add    $0x28,%rsp
  80458e:	5b                   	pop    %rbx
  80458f:	5d                   	pop    %rbp
  804590:	c3                   	retq   

0000000000804591 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804591:	55                   	push   %rbp
  804592:	48 89 e5             	mov    %rsp,%rbp
  804595:	48 83 ec 30          	sub    $0x30,%rsp
  804599:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80459c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8045a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8045a3:	48 89 d6             	mov    %rdx,%rsi
  8045a6:	89 c7                	mov    %eax,%edi
  8045a8:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  8045af:	00 00 00 
  8045b2:	ff d0                	callq  *%rax
  8045b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045bb:	79 05                	jns    8045c2 <pipeisclosed+0x31>
		return r;
  8045bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c0:	eb 31                	jmp    8045f3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8045c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045c6:	48 89 c7             	mov    %rax,%rdi
  8045c9:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8045d0:	00 00 00 
  8045d3:	ff d0                	callq  *%rax
  8045d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8045d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045e1:	48 89 d6             	mov    %rdx,%rsi
  8045e4:	48 89 c7             	mov    %rax,%rdi
  8045e7:	48 b8 be 44 80 00 00 	movabs $0x8044be,%rax
  8045ee:	00 00 00 
  8045f1:	ff d0                	callq  *%rax
}
  8045f3:	c9                   	leaveq 
  8045f4:	c3                   	retq   

00000000008045f5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045f5:	55                   	push   %rbp
  8045f6:	48 89 e5             	mov    %rsp,%rbp
  8045f9:	48 83 ec 40          	sub    $0x40,%rsp
  8045fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804601:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804605:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80460d:	48 89 c7             	mov    %rax,%rdi
  804610:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  804617:	00 00 00 
  80461a:	ff d0                	callq  *%rax
  80461c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804620:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804624:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804628:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80462f:	00 
  804630:	e9 92 00 00 00       	jmpq   8046c7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804635:	eb 41                	jmp    804678 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804637:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80463c:	74 09                	je     804647 <devpipe_read+0x52>
				return i;
  80463e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804642:	e9 92 00 00 00       	jmpq   8046d9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804647:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80464b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80464f:	48 89 d6             	mov    %rdx,%rsi
  804652:	48 89 c7             	mov    %rax,%rdi
  804655:	48 b8 be 44 80 00 00 	movabs $0x8044be,%rax
  80465c:	00 00 00 
  80465f:	ff d0                	callq  *%rax
  804661:	85 c0                	test   %eax,%eax
  804663:	74 07                	je     80466c <devpipe_read+0x77>
				return 0;
  804665:	b8 00 00 00 00       	mov    $0x0,%eax
  80466a:	eb 6d                	jmp    8046d9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80466c:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  804673:	00 00 00 
  804676:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467c:	8b 10                	mov    (%rax),%edx
  80467e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804682:	8b 40 04             	mov    0x4(%rax),%eax
  804685:	39 c2                	cmp    %eax,%edx
  804687:	74 ae                	je     804637 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80468d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804691:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804699:	8b 00                	mov    (%rax),%eax
  80469b:	99                   	cltd   
  80469c:	c1 ea 1b             	shr    $0x1b,%edx
  80469f:	01 d0                	add    %edx,%eax
  8046a1:	83 e0 1f             	and    $0x1f,%eax
  8046a4:	29 d0                	sub    %edx,%eax
  8046a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046aa:	48 98                	cltq   
  8046ac:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8046b1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8046b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b7:	8b 00                	mov    (%rax),%eax
  8046b9:	8d 50 01             	lea    0x1(%rax),%edx
  8046bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8046c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046cb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046cf:	0f 82 60 ff ff ff    	jb     804635 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8046d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8046d9:	c9                   	leaveq 
  8046da:	c3                   	retq   

00000000008046db <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046db:	55                   	push   %rbp
  8046dc:	48 89 e5             	mov    %rsp,%rbp
  8046df:	48 83 ec 40          	sub    $0x40,%rsp
  8046e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8046ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f3:	48 89 c7             	mov    %rax,%rdi
  8046f6:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8046fd:	00 00 00 
  804700:	ff d0                	callq  *%rax
  804702:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804706:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80470a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80470e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804715:	00 
  804716:	e9 8e 00 00 00       	jmpq   8047a9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80471b:	eb 31                	jmp    80474e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80471d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804725:	48 89 d6             	mov    %rdx,%rsi
  804728:	48 89 c7             	mov    %rax,%rdi
  80472b:	48 b8 be 44 80 00 00 	movabs $0x8044be,%rax
  804732:	00 00 00 
  804735:	ff d0                	callq  *%rax
  804737:	85 c0                	test   %eax,%eax
  804739:	74 07                	je     804742 <devpipe_write+0x67>
				return 0;
  80473b:	b8 00 00 00 00       	mov    $0x0,%eax
  804740:	eb 79                	jmp    8047bb <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804742:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  804749:	00 00 00 
  80474c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80474e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804752:	8b 40 04             	mov    0x4(%rax),%eax
  804755:	48 63 d0             	movslq %eax,%rdx
  804758:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80475c:	8b 00                	mov    (%rax),%eax
  80475e:	48 98                	cltq   
  804760:	48 83 c0 20          	add    $0x20,%rax
  804764:	48 39 c2             	cmp    %rax,%rdx
  804767:	73 b4                	jae    80471d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80476d:	8b 40 04             	mov    0x4(%rax),%eax
  804770:	99                   	cltd   
  804771:	c1 ea 1b             	shr    $0x1b,%edx
  804774:	01 d0                	add    %edx,%eax
  804776:	83 e0 1f             	and    $0x1f,%eax
  804779:	29 d0                	sub    %edx,%eax
  80477b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80477f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804783:	48 01 ca             	add    %rcx,%rdx
  804786:	0f b6 0a             	movzbl (%rdx),%ecx
  804789:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80478d:	48 98                	cltq   
  80478f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804793:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804797:	8b 40 04             	mov    0x4(%rax),%eax
  80479a:	8d 50 01             	lea    0x1(%rax),%edx
  80479d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047a1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8047a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047ad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8047b1:	0f 82 64 ff ff ff    	jb     80471b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8047b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8047bb:	c9                   	leaveq 
  8047bc:	c3                   	retq   

00000000008047bd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8047bd:	55                   	push   %rbp
  8047be:	48 89 e5             	mov    %rsp,%rbp
  8047c1:	48 83 ec 20          	sub    $0x20,%rsp
  8047c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8047cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d1:	48 89 c7             	mov    %rax,%rdi
  8047d4:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8047db:	00 00 00 
  8047de:	ff d0                	callq  *%rax
  8047e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8047e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e8:	48 be 68 56 80 00 00 	movabs $0x805668,%rsi
  8047ef:	00 00 00 
  8047f2:	48 89 c7             	mov    %rax,%rdi
  8047f5:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8047fc:	00 00 00 
  8047ff:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804805:	8b 50 04             	mov    0x4(%rax),%edx
  804808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80480c:	8b 00                	mov    (%rax),%eax
  80480e:	29 c2                	sub    %eax,%edx
  804810:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804814:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80481a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80481e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804825:	00 00 00 
	stat->st_dev = &devpipe;
  804828:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80482c:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804833:	00 00 00 
  804836:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80483d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804842:	c9                   	leaveq 
  804843:	c3                   	retq   

0000000000804844 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804844:	55                   	push   %rbp
  804845:	48 89 e5             	mov    %rsp,%rbp
  804848:	48 83 ec 10          	sub    $0x10,%rsp
  80484c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804850:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804854:	48 89 c6             	mov    %rax,%rsi
  804857:	bf 00 00 00 00       	mov    $0x0,%edi
  80485c:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  804863:	00 00 00 
  804866:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804868:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80486c:	48 89 c7             	mov    %rax,%rdi
  80486f:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  804876:	00 00 00 
  804879:	ff d0                	callq  *%rax
  80487b:	48 89 c6             	mov    %rax,%rsi
  80487e:	bf 00 00 00 00       	mov    $0x0,%edi
  804883:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  80488a:	00 00 00 
  80488d:	ff d0                	callq  *%rax
}
  80488f:	c9                   	leaveq 
  804890:	c3                   	retq   

0000000000804891 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804891:	55                   	push   %rbp
  804892:	48 89 e5             	mov    %rsp,%rbp
  804895:	48 83 ec 20          	sub    $0x20,%rsp
  804899:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80489c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80489f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8048a2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8048a6:	be 01 00 00 00       	mov    $0x1,%esi
  8048ab:	48 89 c7             	mov    %rax,%rdi
  8048ae:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  8048b5:	00 00 00 
  8048b8:	ff d0                	callq  *%rax
}
  8048ba:	c9                   	leaveq 
  8048bb:	c3                   	retq   

00000000008048bc <getchar>:

int
getchar(void)
{
  8048bc:	55                   	push   %rbp
  8048bd:	48 89 e5             	mov    %rsp,%rbp
  8048c0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8048c4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8048c8:	ba 01 00 00 00       	mov    $0x1,%edx
  8048cd:	48 89 c6             	mov    %rax,%rsi
  8048d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8048d5:	48 b8 a9 2f 80 00 00 	movabs $0x802fa9,%rax
  8048dc:	00 00 00 
  8048df:	ff d0                	callq  *%rax
  8048e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8048e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048e8:	79 05                	jns    8048ef <getchar+0x33>
		return r;
  8048ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048ed:	eb 14                	jmp    804903 <getchar+0x47>
	if (r < 1)
  8048ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048f3:	7f 07                	jg     8048fc <getchar+0x40>
		return -E_EOF;
  8048f5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8048fa:	eb 07                	jmp    804903 <getchar+0x47>
	return c;
  8048fc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804900:	0f b6 c0             	movzbl %al,%eax

}
  804903:	c9                   	leaveq 
  804904:	c3                   	retq   

0000000000804905 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804905:	55                   	push   %rbp
  804906:	48 89 e5             	mov    %rsp,%rbp
  804909:	48 83 ec 20          	sub    $0x20,%rsp
  80490d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804910:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804914:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804917:	48 89 d6             	mov    %rdx,%rsi
  80491a:	89 c7                	mov    %eax,%edi
  80491c:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  804923:	00 00 00 
  804926:	ff d0                	callq  *%rax
  804928:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80492b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80492f:	79 05                	jns    804936 <iscons+0x31>
		return r;
  804931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804934:	eb 1a                	jmp    804950 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804936:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80493a:	8b 10                	mov    (%rax),%edx
  80493c:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804943:	00 00 00 
  804946:	8b 00                	mov    (%rax),%eax
  804948:	39 c2                	cmp    %eax,%edx
  80494a:	0f 94 c0             	sete   %al
  80494d:	0f b6 c0             	movzbl %al,%eax
}
  804950:	c9                   	leaveq 
  804951:	c3                   	retq   

0000000000804952 <opencons>:

int
opencons(void)
{
  804952:	55                   	push   %rbp
  804953:	48 89 e5             	mov    %rsp,%rbp
  804956:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80495a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80495e:	48 89 c7             	mov    %rax,%rdi
  804961:	48 b8 df 2a 80 00 00 	movabs $0x802adf,%rax
  804968:	00 00 00 
  80496b:	ff d0                	callq  *%rax
  80496d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804970:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804974:	79 05                	jns    80497b <opencons+0x29>
		return r;
  804976:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804979:	eb 5b                	jmp    8049d6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80497b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80497f:	ba 07 04 00 00       	mov    $0x407,%edx
  804984:	48 89 c6             	mov    %rax,%rsi
  804987:	bf 00 00 00 00       	mov    $0x0,%edi
  80498c:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  804993:	00 00 00 
  804996:	ff d0                	callq  *%rax
  804998:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80499b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80499f:	79 05                	jns    8049a6 <opencons+0x54>
		return r;
  8049a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049a4:	eb 30                	jmp    8049d6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8049a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049aa:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8049b1:	00 00 00 
  8049b4:	8b 12                	mov    (%rdx),%edx
  8049b6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8049b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049bc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8049c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049c7:	48 89 c7             	mov    %rax,%rdi
  8049ca:	48 b8 91 2a 80 00 00 	movabs $0x802a91,%rax
  8049d1:	00 00 00 
  8049d4:	ff d0                	callq  *%rax
}
  8049d6:	c9                   	leaveq 
  8049d7:	c3                   	retq   

00000000008049d8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8049d8:	55                   	push   %rbp
  8049d9:	48 89 e5             	mov    %rsp,%rbp
  8049dc:	48 83 ec 30          	sub    $0x30,%rsp
  8049e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8049e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8049ec:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8049f1:	75 07                	jne    8049fa <devcons_read+0x22>
		return 0;
  8049f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8049f8:	eb 4b                	jmp    804a45 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8049fa:	eb 0c                	jmp    804a08 <devcons_read+0x30>
		sys_yield();
  8049fc:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  804a03:	00 00 00 
  804a06:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804a08:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  804a0f:	00 00 00 
  804a12:	ff d0                	callq  *%rax
  804a14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a1b:	74 df                	je     8049fc <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804a1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a21:	79 05                	jns    804a28 <devcons_read+0x50>
		return c;
  804a23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a26:	eb 1d                	jmp    804a45 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804a28:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804a2c:	75 07                	jne    804a35 <devcons_read+0x5d>
		return 0;
  804a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  804a33:	eb 10                	jmp    804a45 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a38:	89 c2                	mov    %eax,%edx
  804a3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a3e:	88 10                	mov    %dl,(%rax)
	return 1;
  804a40:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804a45:	c9                   	leaveq 
  804a46:	c3                   	retq   

0000000000804a47 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a47:	55                   	push   %rbp
  804a48:	48 89 e5             	mov    %rsp,%rbp
  804a4b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804a52:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804a59:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804a60:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804a67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a6e:	eb 76                	jmp    804ae6 <devcons_write+0x9f>
		m = n - tot;
  804a70:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804a77:	89 c2                	mov    %eax,%edx
  804a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a7c:	29 c2                	sub    %eax,%edx
  804a7e:	89 d0                	mov    %edx,%eax
  804a80:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804a83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a86:	83 f8 7f             	cmp    $0x7f,%eax
  804a89:	76 07                	jbe    804a92 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804a8b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804a92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a95:	48 63 d0             	movslq %eax,%rdx
  804a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a9b:	48 63 c8             	movslq %eax,%rcx
  804a9e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804aa5:	48 01 c1             	add    %rax,%rcx
  804aa8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804aaf:	48 89 ce             	mov    %rcx,%rsi
  804ab2:	48 89 c7             	mov    %rax,%rdi
  804ab5:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  804abc:	00 00 00 
  804abf:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804ac1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ac4:	48 63 d0             	movslq %eax,%rdx
  804ac7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804ace:	48 89 d6             	mov    %rdx,%rsi
  804ad1:	48 89 c7             	mov    %rax,%rdi
  804ad4:	48 b8 15 1c 80 00 00 	movabs $0x801c15,%rax
  804adb:	00 00 00 
  804ade:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804ae0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ae3:	01 45 fc             	add    %eax,-0x4(%rbp)
  804ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ae9:	48 98                	cltq   
  804aeb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804af2:	0f 82 78 ff ff ff    	jb     804a70 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804afb:	c9                   	leaveq 
  804afc:	c3                   	retq   

0000000000804afd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804afd:	55                   	push   %rbp
  804afe:	48 89 e5             	mov    %rsp,%rbp
  804b01:	48 83 ec 08          	sub    $0x8,%rsp
  804b05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804b09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b0e:	c9                   	leaveq 
  804b0f:	c3                   	retq   

0000000000804b10 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804b10:	55                   	push   %rbp
  804b11:	48 89 e5             	mov    %rsp,%rbp
  804b14:	48 83 ec 10          	sub    $0x10,%rsp
  804b18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b24:	48 be 74 56 80 00 00 	movabs $0x805674,%rsi
  804b2b:	00 00 00 
  804b2e:	48 89 c7             	mov    %rax,%rdi
  804b31:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  804b38:	00 00 00 
  804b3b:	ff d0                	callq  *%rax
	return 0;
  804b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b42:	c9                   	leaveq 
  804b43:	c3                   	retq   

0000000000804b44 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804b44:	55                   	push   %rbp
  804b45:	48 89 e5             	mov    %rsp,%rbp
  804b48:	48 83 ec 20          	sub    $0x20,%rsp
  804b4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804b50:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b57:	00 00 00 
  804b5a:	48 8b 00             	mov    (%rax),%rax
  804b5d:	48 85 c0             	test   %rax,%rax
  804b60:	75 6f                	jne    804bd1 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804b62:	ba 07 00 00 00       	mov    $0x7,%edx
  804b67:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804b6c:	bf 00 00 00 00       	mov    $0x0,%edi
  804b71:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  804b78:	00 00 00 
  804b7b:	ff d0                	callq  *%rax
  804b7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b84:	79 30                	jns    804bb6 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804b86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b89:	89 c1                	mov    %eax,%ecx
  804b8b:	48 ba 80 56 80 00 00 	movabs $0x805680,%rdx
  804b92:	00 00 00 
  804b95:	be 22 00 00 00       	mov    $0x22,%esi
  804b9a:	48 bf 9f 56 80 00 00 	movabs $0x80569f,%rdi
  804ba1:	00 00 00 
  804ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  804ba9:	49 b8 40 06 80 00 00 	movabs $0x800640,%r8
  804bb0:	00 00 00 
  804bb3:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804bb6:	48 be e4 4b 80 00 00 	movabs $0x804be4,%rsi
  804bbd:	00 00 00 
  804bc0:	bf 00 00 00 00       	mov    $0x0,%edi
  804bc5:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  804bcc:	00 00 00 
  804bcf:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804bd1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bd8:	00 00 00 
  804bdb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804bdf:	48 89 10             	mov    %rdx,(%rax)
}
  804be2:	c9                   	leaveq 
  804be3:	c3                   	retq   

0000000000804be4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804be4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804be7:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804bee:	00 00 00 
call *%rax
  804bf1:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804bf3:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804bfa:	00 08 
    movq 152(%rsp), %rax
  804bfc:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804c03:	00 
    movq 136(%rsp), %rbx
  804c04:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804c0b:	00 
movq %rbx, (%rax)
  804c0c:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804c0f:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804c13:	4c 8b 3c 24          	mov    (%rsp),%r15
  804c17:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804c1c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804c21:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804c26:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804c2b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804c30:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804c35:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804c3a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804c3f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804c44:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804c49:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804c4e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804c53:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804c58:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804c5d:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804c61:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804c65:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804c66:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804c6b:	c3                   	retq   

0000000000804c6c <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804c6c:	55                   	push   %rbp
  804c6d:	48 89 e5             	mov    %rsp,%rbp
  804c70:	48 83 ec 18          	sub    $0x18,%rsp
  804c74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c7c:	48 c1 e8 15          	shr    $0x15,%rax
  804c80:	48 89 c2             	mov    %rax,%rdx
  804c83:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c8a:	01 00 00 
  804c8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c91:	83 e0 01             	and    $0x1,%eax
  804c94:	48 85 c0             	test   %rax,%rax
  804c97:	75 07                	jne    804ca0 <pageref+0x34>
		return 0;
  804c99:	b8 00 00 00 00       	mov    $0x0,%eax
  804c9e:	eb 53                	jmp    804cf3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804ca0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ca4:	48 c1 e8 0c          	shr    $0xc,%rax
  804ca8:	48 89 c2             	mov    %rax,%rdx
  804cab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804cb2:	01 00 00 
  804cb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cb9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804cbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cc1:	83 e0 01             	and    $0x1,%eax
  804cc4:	48 85 c0             	test   %rax,%rax
  804cc7:	75 07                	jne    804cd0 <pageref+0x64>
		return 0;
  804cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  804cce:	eb 23                	jmp    804cf3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cd4:	48 c1 e8 0c          	shr    $0xc,%rax
  804cd8:	48 89 c2             	mov    %rax,%rdx
  804cdb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ce2:	00 00 00 
  804ce5:	48 c1 e2 04          	shl    $0x4,%rdx
  804ce9:	48 01 d0             	add    %rdx,%rax
  804cec:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804cf0:	0f b7 c0             	movzwl %ax,%eax
}
  804cf3:	c9                   	leaveq 
  804cf4:	c3                   	retq   
