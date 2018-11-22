
vmm/guest/obj/user/testfile:     file format elf64-x86-64


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
  80003c:	e8 39 0c 00 00       	callq  800c7a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;

	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  800060:	00 00 00 
  800063:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 ea 2a 80 00 00 	movabs $0x802aea,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf c6 4c 80 00 00 	movabs $0x804cc6,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba d1 4c 80 00 00 	movabs $0x804cd1,%rdx
  80012e:	00 00 00 
  800131:	be 21 00 00 00       	mov    $0x21,%esi
  800136:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 00 4d 80 00 00 	movabs $0x804d00,%rdx
  800160:	00 00 00 
  800163:	be 23 00 00 00       	mov    $0x23,%esi
  800168:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 21 4d 80 00 00 	movabs $0x804d21,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba 2a 4d 80 00 00 	movabs $0x804d2a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 26 00 00 00       	mov    $0x26,%esi
  8001c1:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba 48 4d 80 00 00 	movabs $0x804d48,%rdx
  800208:	00 00 00 
  80020b:	be 28 00 00 00       	mov    $0x28,%esi
  800210:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf 75 4d 80 00 00 	movabs $0x804d75,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba 89 4d 80 00 00 	movabs $0x804d89,%rdx
  800280:	00 00 00 
  800283:	be 2c 00 00 00       	mov    $0x2c,%esi
  800288:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2e 00 00 00       	mov    $0x2e,%esi
  8002fc:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf be 4d 80 00 00 	movabs $0x804dbe,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 a7 1d 80 00 00 	movabs $0x801da7,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80035a:	00 00 00 
  80035d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800361:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 ce             	mov    %rcx,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d0                	callq  *%rax
  800377:	48 98                	cltq   
  800379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2de>
		panic("file_read: %e", r);
  800384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba d1 4d 80 00 00 	movabs $0x804dd1,%rdx
  800392:	00 00 00 
  800395:	be 33 00 00 00       	mov    $0x33,%esi
  80039a:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x332>
		panic("file_read returned wrong data");
  8003e0:	48 ba df 4d 80 00 00 	movabs $0x804ddf,%rdx
  8003e7:	00 00 00 
  8003ea:	be 35 00 00 00       	mov    $0x35,%esi
  8003ef:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf fd 4d 80 00 00 	movabs $0x804dfd,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a1>
		panic("file_close: %e", r);
  800447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba 10 4e 80 00 00 	movabs $0x804e10,%rdx
  800455:	00 00 00 
  800458:	be 39 00 00 00       	mov    $0x39,%esi
  80045d:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf 1f 4e 80 00 00 	movabs $0x804e1f,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8004c5:	00 00 00 
  8004c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004cc:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d3:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 cf             	mov    %rcx,%rdi
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 98                	cltq   
  8004e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e7:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ec:	74 32                	je     800520 <umain+0x448>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f2:	48 89 c1             	mov    %rax,%rcx
  8004f5:	48 ba 38 4e 80 00 00 	movabs $0x804e38,%rdx
  8004fc:	00 00 00 
  8004ff:	be 44 00 00 00       	mov    $0x44,%esi
  800504:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf 6f 4e 80 00 00 	movabs $0x804e6f,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf 85 4e 80 00 00 	movabs $0x804e85,%rdi
  800547:	00 00 00 
  80054a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	48 98                	cltq   
  800558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800561:	79 32                	jns    800595 <umain+0x4bd>
		panic("serve_open /new-file: %e", r);
  800563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800567:	48 89 c1             	mov    %rax,%rcx
  80056a:	48 ba 8f 4e 80 00 00 	movabs $0x804e8f,%rdx
  800571:	00 00 00 
  800574:	be 49 00 00 00       	mov    $0x49,%esi
  800579:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800580:	00 00 00 
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80058f:	00 00 00 
  800592:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800595:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80059c:	00 00 00 
  80059f:	48 8b 10             	mov    (%rax),%rdx
  8005a2:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b0:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8005b7:	00 00 00 
  8005ba:	48 8b 08             	mov    (%rax),%rcx
  8005bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005c5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8005ca:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8005ce:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8005d3:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8005d7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8005dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8005e0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8005e5:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8005e9:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8005ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8005f2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8005f7:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005fc:	48 bf a8 4e 80 00 00 	movabs $0x804ea8,%rdi
  800603:	00 00 00 
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	49 b8 59 0f 80 00 00 	movabs $0x800f59,%r8
  800612:	00 00 00 
  800615:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800618:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80061f:	00 00 00 
  800622:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800626:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	48 63 d0             	movslq %eax,%rdx
  800645:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80064c:	00 00 00 
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 c6             	mov    %rax,%rsi
  800655:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80065a:	ff d3                	callq  *%rbx
  80065c:	48 98                	cltq   
  80065e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800662:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800669:	00 00 00 
  80066c:	48 8b 00             	mov    (%rax),%rax
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
  80067e:	48 98                	cltq   
  800680:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800684:	74 32                	je     8006b8 <umain+0x5e0>
		panic("file_write: %e", r);
  800686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80068a:	48 89 c1             	mov    %rax,%rcx
  80068d:	48 ba e8 4e 80 00 00 	movabs $0x804ee8,%rdx
  800694:	00 00 00 
  800697:	be 4e 00 00 00       	mov    $0x4e,%esi
  80069c:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf f7 4e 80 00 00 	movabs $0x804ef7,%rdi
  8006bf:	00 00 00 
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  8006ce:	00 00 00 
  8006d1:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006d3:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006df:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006e6:	ba 00 02 00 00       	mov    $0x200,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 a7 1d 80 00 00 	movabs $0x801da7,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006ff:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  800706:	00 00 00 
  800709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80070d:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800714:	ba 00 02 00 00       	mov    $0x200,%edx
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800721:	ff d0                	callq  *%rax
  800723:	48 98                	cltq   
  800725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800729:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80072e:	79 32                	jns    800762 <umain+0x68a>
		panic("file_read after file_write: %e", r);
  800730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800734:	48 89 c1             	mov    %rax,%rcx
  800737:	48 ba 10 4f 80 00 00 	movabs $0x804f10,%rdx
  80073e:	00 00 00 
  800741:	be 54 00 00 00       	mov    $0x54,%esi
  800746:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  80074d:	00 00 00 
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80075c:	00 00 00 
  80075f:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800762:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800769:	00 00 00 
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	48 98                	cltq   
  800780:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800784:	74 32                	je     8007b8 <umain+0x6e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80078a:	48 89 c1             	mov    %rax,%rcx
  80078d:	48 ba 30 4f 80 00 00 	movabs $0x804f30,%rdx
  800794:	00 00 00 
  800797:	be 56 00 00 00       	mov    $0x56,%esi
  80079c:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8007b2:	00 00 00 
  8007b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8007b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8007bf:	00 00 00 
  8007c2:	48 8b 10             	mov    (%rax),%rdx
  8007c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	48 89 c7             	mov    %rax,%rdi
  8007d2:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	74 2a                	je     80080c <umain+0x734>
		panic("file_read after file_write returned wrong data");
  8007e2:	48 ba 68 4f 80 00 00 	movabs $0x804f68,%rdx
  8007e9:	00 00 00 
  8007ec:	be 58 00 00 00       	mov    $0x58,%esi
  8007f1:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf 98 4f 80 00 00 	movabs $0x804f98,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf c6 4c 80 00 00 	movabs $0x804cc6,%rdi
  800833:	00 00 00 
  800836:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	48 98                	cltq   
  800844:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800848:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80084d:	79 39                	jns    800888 <umain+0x7b0>
  80084f:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800854:	74 32                	je     800888 <umain+0x7b0>
		panic("open /not-found: %e", r);
  800856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085a:	48 89 c1             	mov    %rax,%rcx
  80085d:	48 ba bc 4f 80 00 00 	movabs $0x804fbc,%rdx
  800864:	00 00 00 
  800867:	be 5d 00 00 00       	mov    $0x5d,%esi
  80086c:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba d0 4f 80 00 00 	movabs $0x804fd0,%rdx
  800896:	00 00 00 
  800899:	be 5f 00 00 00       	mov    $0x5f,%esi
  80089e:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf 21 4d 80 00 00 	movabs $0x804d21,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba eb 4f 80 00 00 	movabs $0x804feb,%rdx
  8008ef:	00 00 00 
  8008f2:	be 62 00 00 00       	mov    $0x62,%esi
  8008f7:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8008fe:	00 00 00 
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80090d:	00 00 00 
  800910:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 66             	cmp    $0x66,%eax
  80092e:	75 16                	jne    800946 <umain+0x86e>
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	8b 40 04             	mov    0x4(%rax),%eax
  800937:	85 c0                	test   %eax,%eax
  800939:	75 0b                	jne    800946 <umain+0x86e>
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	8b 40 08             	mov    0x8(%rax),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 2a                	je     800970 <umain+0x898>
		panic("open did not fill struct Fd correctly\n");
  800946:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  80094d:	00 00 00 
  800950:	be 65 00 00 00       	mov    $0x65,%esi
  800955:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf 27 50 80 00 00 	movabs $0x805027,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf 35 50 80 00 00 	movabs $0x805035,%rdi
  800997:	00 00 00 
  80099a:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba 3a 50 80 00 00 	movabs $0x80503a,%rdx
  8009c1:	00 00 00 
  8009c4:	be 6a 00 00 00       	mov    $0x6a,%esi
  8009c9:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8009df:	00 00 00 
  8009e2:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009e5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009ec:	ba 00 02 00 00       	mov    $0x200,%edx
  8009f1:	be 00 00 00 00       	mov    $0x0,%esi
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 a7 1d 80 00 00 	movabs $0x801da7,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a0c:	00 
  800a0d:	e9 82 00 00 00       	jmpq   800a94 <umain+0x9bc>
		*(int*)buf = i;
  800a12:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a23:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800a2a:	ba 00 02 00 00       	mov    $0x200,%edx
  800a2f:	48 89 ce             	mov    %rcx,%rsi
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	48 b8 be 31 80 00 00 	movabs $0x8031be,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a4b:	79 39                	jns    800a86 <umain+0x9ae>
			panic("write /big@%d: %e", i, r);
  800a4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	49 89 d0             	mov    %rdx,%r8
  800a58:	48 89 c1             	mov    %rax,%rcx
  800a5b:	48 ba 49 50 80 00 00 	movabs $0x805049,%rdx
  800a62:	00 00 00 
  800a65:	be 6f 00 00 00       	mov    $0x6f,%esi
  800a6a:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800a71:	00 00 00 
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800a80:	00 00 00 
  800a83:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 05 00 02 00 00    	add    $0x200,%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a94:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a9b:	00 
  800a9c:	0f 8e 70 ff ff ff    	jle    800a12 <umain+0x93a>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf 35 50 80 00 00 	movabs $0x805035,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba 5b 50 80 00 00 	movabs $0x80505b,%rdx
  800aea:	00 00 00 
  800aed:	be 74 00 00 00       	mov    $0x74,%esi
  800af2:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800b0e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800b15:	00 
  800b16:	e9 1a 01 00 00       	jmpq   800c35 <umain+0xb5d>
		*(int*)buf = i;
  800b1b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b2c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800b33:	ba 00 02 00 00       	mov    $0x200,%edx
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	48 98                	cltq   
  800b4b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b54:	79 39                	jns    800b8f <umain+0xab7>
			panic("read /big@%d: %e", i, r);
  800b56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	49 89 d0             	mov    %rdx,%r8
  800b61:	48 89 c1             	mov    %rax,%rcx
  800b64:	48 ba 69 50 80 00 00 	movabs $0x805069,%rdx
  800b6b:	00 00 00 
  800b6e:	be 78 00 00 00       	mov    $0x78,%esi
  800b73:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800b7a:	00 00 00 
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800b89:	00 00 00 
  800b8c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b8f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b96:	00 
  800b97:	74 3f                	je     800bd8 <umain+0xb00>
			panic("read /big from %d returned %d < %d bytes",
  800b99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800ba7:	49 89 d0             	mov    %rdx,%r8
  800baa:	48 89 c1             	mov    %rax,%rcx
  800bad:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7b 00 00 00       	mov    $0x7b,%esi
  800bbc:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800bc3:	00 00 00 
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	49 ba 20 0d 80 00 00 	movabs $0x800d20,%r10
  800bd2:	00 00 00 
  800bd5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bd8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 98                	cltq   
  800be3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800be7:	74 3e                	je     800c27 <umain+0xb4f>
			panic("read /big from %d returned bad data %d",
  800be9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bf0:	8b 10                	mov    (%rax),%edx
  800bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf6:	41 89 d0             	mov    %edx,%r8d
  800bf9:	48 89 c1             	mov    %rax,%rcx
  800bfc:	48 ba b0 50 80 00 00 	movabs $0x8050b0,%rdx
  800c03:	00 00 00 
  800c06:	be 7e 00 00 00       	mov    $0x7e,%esi
  800c0b:	48 bf eb 4c 80 00 00 	movabs $0x804ceb,%rdi
  800c12:	00 00 00 
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800c21:	00 00 00 
  800c24:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 05 00 02 00 00    	add    $0x200,%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c35:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c3c:	00 
  800c3d:	0f 8e d8 fe ff ff    	jle    800b1b <umain+0xa43>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf d7 50 80 00 00 	movabs $0x8050d7,%rdi
  800c5c:	00 00 00 
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800c6b:	00 00 00 
  800c6e:	ff d2                	callq  *%rdx
}
  800c70:	48 81 c4 18 03 00 00 	add    $0x318,%rsp
  800c77:	5b                   	pop    %rbx
  800c78:	5d                   	pop    %rbp
  800c79:	c3                   	retq   

0000000000800c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c7a:	55                   	push   %rbp
  800c7b:	48 89 e5             	mov    %rsp,%rbp
  800c7e:	48 83 ec 10          	sub    $0x10,%rsp
  800c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800c89:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	25 ff 03 00 00       	and    $0x3ff,%eax
  800c9a:	48 98                	cltq   
  800c9c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800ca3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800caa:	00 00 00 
  800cad:	48 01 c2             	add    %rax,%rdx
  800cb0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800cb7:	00 00 00 
  800cba:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800cbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc1:	7e 14                	jle    800cd7 <libmain+0x5d>
		binaryname = argv[0];
  800cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc7:	48 8b 10             	mov    (%rax),%rdx
  800cca:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cd1:	00 00 00 
  800cd4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800cd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cde:	48 89 d6             	mov    %rdx,%rsi
  800ce1:	89 c7                	mov    %eax,%edi
  800ce3:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800cea:	00 00 00 
  800ced:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cef:	48 b8 fd 0c 80 00 00 	movabs $0x800cfd,%rax
  800cf6:	00 00 00 
  800cf9:	ff d0                	callq  *%rax
}
  800cfb:	c9                   	leaveq 
  800cfc:	c3                   	retq   

0000000000800cfd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800cfd:	55                   	push   %rbp
  800cfe:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800d01:	48 b8 9d 2e 80 00 00 	movabs $0x802e9d,%rax
  800d08:	00 00 00 
  800d0b:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800d12:	48 b8 7d 23 80 00 00 	movabs $0x80237d,%rax
  800d19:	00 00 00 
  800d1c:	ff d0                	callq  *%rax
}
  800d1e:	5d                   	pop    %rbp
  800d1f:	c3                   	retq   

0000000000800d20 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d20:	55                   	push   %rbp
  800d21:	48 89 e5             	mov    %rsp,%rbp
  800d24:	53                   	push   %rbx
  800d25:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d2c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d33:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d39:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d40:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d47:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 23                	je     800d75 <_panic+0x55>
  800d52:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d59:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d5d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d61:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d65:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d69:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d6d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d71:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d75:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d7c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d83:	00 00 00 
  800d86:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d8d:	00 00 00 
  800d90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d94:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800d9b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800da2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800da9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800db0:	00 00 00 
  800db3:	48 8b 18             	mov    (%rax),%rbx
  800db6:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  800dbd:	00 00 00 
  800dc0:	ff d0                	callq  *%rax
  800dc2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dc8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dcf:	41 89 c8             	mov    %ecx,%r8d
  800dd2:	48 89 d1             	mov    %rdx,%rcx
  800dd5:	48 89 da             	mov    %rbx,%rdx
  800dd8:	89 c6                	mov    %eax,%esi
  800dda:	48 bf f8 50 80 00 00 	movabs $0x8050f8,%rdi
  800de1:	00 00 00 
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	49 b9 59 0f 80 00 00 	movabs $0x800f59,%r9
  800df0:	00 00 00 
  800df3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800df6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800dfd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e04:	48 89 d6             	mov    %rdx,%rsi
  800e07:	48 89 c7             	mov    %rax,%rdi
  800e0a:	48 b8 ad 0e 80 00 00 	movabs $0x800ead,%rax
  800e11:	00 00 00 
  800e14:	ff d0                	callq  *%rax
	cprintf("\n");
  800e16:	48 bf 1b 51 80 00 00 	movabs $0x80511b,%rdi
  800e1d:	00 00 00 
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
  800e25:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800e2c:	00 00 00 
  800e2f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e31:	cc                   	int3   
  800e32:	eb fd                	jmp    800e31 <_panic+0x111>

0000000000800e34 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 83 ec 10          	sub    $0x10,%rsp
  800e3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e47:	8b 00                	mov    (%rax),%eax
  800e49:	8d 48 01             	lea    0x1(%rax),%ecx
  800e4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e50:	89 0a                	mov    %ecx,(%rdx)
  800e52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e55:	89 d1                	mov    %edx,%ecx
  800e57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5b:	48 98                	cltq   
  800e5d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	8b 00                	mov    (%rax),%eax
  800e67:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e6c:	75 2c                	jne    800e9a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e72:	8b 00                	mov    (%rax),%eax
  800e74:	48 98                	cltq   
  800e76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e7a:	48 83 c2 08          	add    $0x8,%rdx
  800e7e:	48 89 c6             	mov    %rax,%rsi
  800e81:	48 89 d7             	mov    %rdx,%rdi
  800e84:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	callq  *%rax
        b->idx = 0;
  800e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e94:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9e:	8b 40 04             	mov    0x4(%rax),%eax
  800ea1:	8d 50 01             	lea    0x1(%rax),%edx
  800ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea8:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eab:	c9                   	leaveq 
  800eac:	c3                   	retq   

0000000000800ead <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800ead:	55                   	push   %rbp
  800eae:	48 89 e5             	mov    %rsp,%rbp
  800eb1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800eb8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ebf:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800ec6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ecd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ed4:	48 8b 0a             	mov    (%rdx),%rcx
  800ed7:	48 89 08             	mov    %rcx,(%rax)
  800eda:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ede:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800eea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ef1:	00 00 00 
    b.cnt = 0;
  800ef4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800efb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800efe:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f05:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f0c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f13:	48 89 c6             	mov    %rax,%rsi
  800f16:	48 bf 34 0e 80 00 00 	movabs $0x800e34,%rdi
  800f1d:	00 00 00 
  800f20:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800f2c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f32:	48 98                	cltq   
  800f34:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f3b:	48 83 c2 08          	add    $0x8,%rdx
  800f3f:	48 89 c6             	mov    %rax,%rsi
  800f42:	48 89 d7             	mov    %rdx,%rdi
  800f45:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  800f4c:	00 00 00 
  800f4f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800f51:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f57:	c9                   	leaveq 
  800f58:	c3                   	retq   

0000000000800f59 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800f59:	55                   	push   %rbp
  800f5a:	48 89 e5             	mov    %rsp,%rbp
  800f5d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f64:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f6b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f72:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f79:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f80:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f87:	84 c0                	test   %al,%al
  800f89:	74 20                	je     800fab <cprintf+0x52>
  800f8b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f8f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f93:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f97:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f9b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f9f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fab:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800fb2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fb9:	00 00 00 
  800fbc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fc3:	00 00 00 
  800fc6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800fdf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fe6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fed:	48 8b 0a             	mov    (%rdx),%rcx
  800ff0:	48 89 08             	mov    %rcx,(%rax)
  800ff3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ffb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fff:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801003:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80100a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801011:	48 89 d6             	mov    %rdx,%rsi
  801014:	48 89 c7             	mov    %rax,%rdi
  801017:	48 b8 ad 0e 80 00 00 	movabs $0x800ead,%rax
  80101e:	00 00 00 
  801021:	ff d0                	callq  *%rax
  801023:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801029:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	53                   	push   %rbx
  801036:	48 83 ec 38          	sub    $0x38,%rsp
  80103a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801042:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801046:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801049:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80104d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801051:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801054:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801058:	77 3b                	ja     801095 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80105a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80105d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801061:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801068:	ba 00 00 00 00       	mov    $0x0,%edx
  80106d:	48 f7 f3             	div    %rbx
  801070:	48 89 c2             	mov    %rax,%rdx
  801073:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801076:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801079:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80107d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801081:	41 89 f9             	mov    %edi,%r9d
  801084:	48 89 c7             	mov    %rax,%rdi
  801087:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  80108e:	00 00 00 
  801091:	ff d0                	callq  *%rax
  801093:	eb 1e                	jmp    8010b3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801095:	eb 12                	jmp    8010a9 <printnum+0x78>
			putch(padc, putdat);
  801097:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80109b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	48 89 ce             	mov    %rcx,%rsi
  8010a5:	89 d7                	mov    %edx,%edi
  8010a7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010a9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8010ad:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8010b1:	7f e4                	jg     801097 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8010b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bf:	48 f7 f1             	div    %rcx
  8010c2:	48 89 d0             	mov    %rdx,%rax
  8010c5:	48 ba 10 53 80 00 00 	movabs $0x805310,%rdx
  8010cc:	00 00 00 
  8010cf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010d3:	0f be d0             	movsbl %al,%edx
  8010d6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	48 89 ce             	mov    %rcx,%rsi
  8010e1:	89 d7                	mov    %edx,%edi
  8010e3:	ff d0                	callq  *%rax
}
  8010e5:	48 83 c4 38          	add    $0x38,%rsp
  8010e9:	5b                   	pop    %rbx
  8010ea:	5d                   	pop    %rbp
  8010eb:	c3                   	retq   

00000000008010ec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010ec:	55                   	push   %rbp
  8010ed:	48 89 e5             	mov    %rsp,%rbp
  8010f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8010f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8010fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010ff:	7e 52                	jle    801153 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	8b 00                	mov    (%rax),%eax
  801107:	83 f8 30             	cmp    $0x30,%eax
  80110a:	73 24                	jae    801130 <getuint+0x44>
  80110c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801110:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801118:	8b 00                	mov    (%rax),%eax
  80111a:	89 c0                	mov    %eax,%eax
  80111c:	48 01 d0             	add    %rdx,%rax
  80111f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801123:	8b 12                	mov    (%rdx),%edx
  801125:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801128:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80112c:	89 0a                	mov    %ecx,(%rdx)
  80112e:	eb 17                	jmp    801147 <getuint+0x5b>
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801138:	48 89 d0             	mov    %rdx,%rax
  80113b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80113f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801143:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801147:	48 8b 00             	mov    (%rax),%rax
  80114a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80114e:	e9 a3 00 00 00       	jmpq   8011f6 <getuint+0x10a>
	else if (lflag)
  801153:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801157:	74 4f                	je     8011a8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115d:	8b 00                	mov    (%rax),%eax
  80115f:	83 f8 30             	cmp    $0x30,%eax
  801162:	73 24                	jae    801188 <getuint+0x9c>
  801164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801168:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	8b 00                	mov    (%rax),%eax
  801172:	89 c0                	mov    %eax,%eax
  801174:	48 01 d0             	add    %rdx,%rax
  801177:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80117b:	8b 12                	mov    (%rdx),%edx
  80117d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801180:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801184:	89 0a                	mov    %ecx,(%rdx)
  801186:	eb 17                	jmp    80119f <getuint+0xb3>
  801188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801190:	48 89 d0             	mov    %rdx,%rax
  801193:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801197:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80119f:	48 8b 00             	mov    (%rax),%rax
  8011a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011a6:	eb 4e                	jmp    8011f6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ac:	8b 00                	mov    (%rax),%eax
  8011ae:	83 f8 30             	cmp    $0x30,%eax
  8011b1:	73 24                	jae    8011d7 <getuint+0xeb>
  8011b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bf:	8b 00                	mov    (%rax),%eax
  8011c1:	89 c0                	mov    %eax,%eax
  8011c3:	48 01 d0             	add    %rdx,%rax
  8011c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ca:	8b 12                	mov    (%rdx),%edx
  8011cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d3:	89 0a                	mov    %ecx,(%rdx)
  8011d5:	eb 17                	jmp    8011ee <getuint+0x102>
  8011d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011df:	48 89 d0             	mov    %rdx,%rax
  8011e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011ee:	8b 00                	mov    (%rax),%eax
  8011f0:	89 c0                	mov    %eax,%eax
  8011f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011fa:	c9                   	leaveq 
  8011fb:	c3                   	retq   

00000000008011fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	48 83 ec 1c          	sub    $0x1c,%rsp
  801204:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801208:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80120b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80120f:	7e 52                	jle    801263 <getint+0x67>
		x=va_arg(*ap, long long);
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801215:	8b 00                	mov    (%rax),%eax
  801217:	83 f8 30             	cmp    $0x30,%eax
  80121a:	73 24                	jae    801240 <getint+0x44>
  80121c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801220:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	8b 00                	mov    (%rax),%eax
  80122a:	89 c0                	mov    %eax,%eax
  80122c:	48 01 d0             	add    %rdx,%rax
  80122f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801233:	8b 12                	mov    (%rdx),%edx
  801235:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801238:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123c:	89 0a                	mov    %ecx,(%rdx)
  80123e:	eb 17                	jmp    801257 <getint+0x5b>
  801240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801244:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801248:	48 89 d0             	mov    %rdx,%rax
  80124b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80124f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801253:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801257:	48 8b 00             	mov    (%rax),%rax
  80125a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80125e:	e9 a3 00 00 00       	jmpq   801306 <getint+0x10a>
	else if (lflag)
  801263:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801267:	74 4f                	je     8012b8 <getint+0xbc>
		x=va_arg(*ap, long);
  801269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126d:	8b 00                	mov    (%rax),%eax
  80126f:	83 f8 30             	cmp    $0x30,%eax
  801272:	73 24                	jae    801298 <getint+0x9c>
  801274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801278:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	8b 00                	mov    (%rax),%eax
  801282:	89 c0                	mov    %eax,%eax
  801284:	48 01 d0             	add    %rdx,%rax
  801287:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80128b:	8b 12                	mov    (%rdx),%edx
  80128d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801290:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801294:	89 0a                	mov    %ecx,(%rdx)
  801296:	eb 17                	jmp    8012af <getint+0xb3>
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012a0:	48 89 d0             	mov    %rdx,%rax
  8012a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012af:	48 8b 00             	mov    (%rax),%rax
  8012b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012b6:	eb 4e                	jmp    801306 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	8b 00                	mov    (%rax),%eax
  8012be:	83 f8 30             	cmp    $0x30,%eax
  8012c1:	73 24                	jae    8012e7 <getint+0xeb>
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	8b 00                	mov    (%rax),%eax
  8012d1:	89 c0                	mov    %eax,%eax
  8012d3:	48 01 d0             	add    %rdx,%rax
  8012d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012da:	8b 12                	mov    (%rdx),%edx
  8012dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e3:	89 0a                	mov    %ecx,(%rdx)
  8012e5:	eb 17                	jmp    8012fe <getint+0x102>
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012ef:	48 89 d0             	mov    %rdx,%rax
  8012f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012fe:	8b 00                	mov    (%rax),%eax
  801300:	48 98                	cltq   
  801302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	41 54                	push   %r12
  801312:	53                   	push   %rbx
  801313:	48 83 ec 60          	sub    $0x60,%rsp
  801317:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80131b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80131f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801323:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801327:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80132b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80132f:	48 8b 0a             	mov    (%rdx),%rcx
  801332:	48 89 08             	mov    %rcx,(%rax)
  801335:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801339:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80133d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801341:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801345:	eb 17                	jmp    80135e <vprintfmt+0x52>
			if (ch == '\0')
  801347:	85 db                	test   %ebx,%ebx
  801349:	0f 84 cc 04 00 00    	je     80181b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80134f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801353:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801357:	48 89 d6             	mov    %rdx,%rsi
  80135a:	89 df                	mov    %ebx,%edi
  80135c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80135e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801362:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801366:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	0f b6 d8             	movzbl %al,%ebx
  801370:	83 fb 25             	cmp    $0x25,%ebx
  801373:	75 d2                	jne    801347 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801375:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801379:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801380:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801387:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80138e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801395:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801399:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80139d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	0f b6 d8             	movzbl %al,%ebx
  8013a7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8013aa:	83 f8 55             	cmp    $0x55,%eax
  8013ad:	0f 87 34 04 00 00    	ja     8017e7 <vprintfmt+0x4db>
  8013b3:	89 c0                	mov    %eax,%eax
  8013b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013bc:	00 
  8013bd:	48 b8 38 53 80 00 00 	movabs $0x805338,%rax
  8013c4:	00 00 00 
  8013c7:	48 01 d0             	add    %rdx,%rax
  8013ca:	48 8b 00             	mov    (%rax),%rax
  8013cd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8013cf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013d3:	eb c0                	jmp    801395 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013d5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013d9:	eb ba                	jmp    801395 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013e2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013e5:	89 d0                	mov    %edx,%eax
  8013e7:	c1 e0 02             	shl    $0x2,%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	01 c0                	add    %eax,%eax
  8013ee:	01 d8                	add    %ebx,%eax
  8013f0:	83 e8 30             	sub    $0x30,%eax
  8013f3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8013f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801400:	83 fb 2f             	cmp    $0x2f,%ebx
  801403:	7e 0c                	jle    801411 <vprintfmt+0x105>
  801405:	83 fb 39             	cmp    $0x39,%ebx
  801408:	7f 07                	jg     801411 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80140a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80140f:	eb d1                	jmp    8013e2 <vprintfmt+0xd6>
			goto process_precision;
  801411:	eb 58                	jmp    80146b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801413:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801416:	83 f8 30             	cmp    $0x30,%eax
  801419:	73 17                	jae    801432 <vprintfmt+0x126>
  80141b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80141f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801422:	89 c0                	mov    %eax,%eax
  801424:	48 01 d0             	add    %rdx,%rax
  801427:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80142a:	83 c2 08             	add    $0x8,%edx
  80142d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801430:	eb 0f                	jmp    801441 <vprintfmt+0x135>
  801432:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801436:	48 89 d0             	mov    %rdx,%rax
  801439:	48 83 c2 08          	add    $0x8,%rdx
  80143d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801441:	8b 00                	mov    (%rax),%eax
  801443:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801446:	eb 23                	jmp    80146b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801448:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80144c:	79 0c                	jns    80145a <vprintfmt+0x14e>
				width = 0;
  80144e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801455:	e9 3b ff ff ff       	jmpq   801395 <vprintfmt+0x89>
  80145a:	e9 36 ff ff ff       	jmpq   801395 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80145f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801466:	e9 2a ff ff ff       	jmpq   801395 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80146b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80146f:	79 12                	jns    801483 <vprintfmt+0x177>
				width = precision, precision = -1;
  801471:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801474:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801477:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80147e:	e9 12 ff ff ff       	jmpq   801395 <vprintfmt+0x89>
  801483:	e9 0d ff ff ff       	jmpq   801395 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801488:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80148c:	e9 04 ff ff ff       	jmpq   801395 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801491:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801494:	83 f8 30             	cmp    $0x30,%eax
  801497:	73 17                	jae    8014b0 <vprintfmt+0x1a4>
  801499:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80149d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a0:	89 c0                	mov    %eax,%eax
  8014a2:	48 01 d0             	add    %rdx,%rax
  8014a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014a8:	83 c2 08             	add    $0x8,%edx
  8014ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014ae:	eb 0f                	jmp    8014bf <vprintfmt+0x1b3>
  8014b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014b4:	48 89 d0             	mov    %rdx,%rax
  8014b7:	48 83 c2 08          	add    $0x8,%rdx
  8014bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014bf:	8b 10                	mov    (%rax),%edx
  8014c1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014c9:	48 89 ce             	mov    %rcx,%rsi
  8014cc:	89 d7                	mov    %edx,%edi
  8014ce:	ff d0                	callq  *%rax
			break;
  8014d0:	e9 40 03 00 00       	jmpq   801815 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8014d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014d8:	83 f8 30             	cmp    $0x30,%eax
  8014db:	73 17                	jae    8014f4 <vprintfmt+0x1e8>
  8014dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e4:	89 c0                	mov    %eax,%eax
  8014e6:	48 01 d0             	add    %rdx,%rax
  8014e9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014ec:	83 c2 08             	add    $0x8,%edx
  8014ef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014f2:	eb 0f                	jmp    801503 <vprintfmt+0x1f7>
  8014f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014f8:	48 89 d0             	mov    %rdx,%rax
  8014fb:	48 83 c2 08          	add    $0x8,%rdx
  8014ff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801503:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801505:	85 db                	test   %ebx,%ebx
  801507:	79 02                	jns    80150b <vprintfmt+0x1ff>
				err = -err;
  801509:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80150b:	83 fb 15             	cmp    $0x15,%ebx
  80150e:	7f 16                	jg     801526 <vprintfmt+0x21a>
  801510:	48 b8 60 52 80 00 00 	movabs $0x805260,%rax
  801517:	00 00 00 
  80151a:	48 63 d3             	movslq %ebx,%rdx
  80151d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801521:	4d 85 e4             	test   %r12,%r12
  801524:	75 2e                	jne    801554 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801526:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80152a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80152e:	89 d9                	mov    %ebx,%ecx
  801530:	48 ba 21 53 80 00 00 	movabs $0x805321,%rdx
  801537:	00 00 00 
  80153a:	48 89 c7             	mov    %rax,%rdi
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	49 b8 24 18 80 00 00 	movabs $0x801824,%r8
  801549:	00 00 00 
  80154c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80154f:	e9 c1 02 00 00       	jmpq   801815 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801554:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801558:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80155c:	4c 89 e1             	mov    %r12,%rcx
  80155f:	48 ba 2a 53 80 00 00 	movabs $0x80532a,%rdx
  801566:	00 00 00 
  801569:	48 89 c7             	mov    %rax,%rdi
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	49 b8 24 18 80 00 00 	movabs $0x801824,%r8
  801578:	00 00 00 
  80157b:	41 ff d0             	callq  *%r8
			break;
  80157e:	e9 92 02 00 00       	jmpq   801815 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801583:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801586:	83 f8 30             	cmp    $0x30,%eax
  801589:	73 17                	jae    8015a2 <vprintfmt+0x296>
  80158b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80158f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801592:	89 c0                	mov    %eax,%eax
  801594:	48 01 d0             	add    %rdx,%rax
  801597:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80159a:	83 c2 08             	add    $0x8,%edx
  80159d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8015a0:	eb 0f                	jmp    8015b1 <vprintfmt+0x2a5>
  8015a2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015a6:	48 89 d0             	mov    %rdx,%rax
  8015a9:	48 83 c2 08          	add    $0x8,%rdx
  8015ad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015b1:	4c 8b 20             	mov    (%rax),%r12
  8015b4:	4d 85 e4             	test   %r12,%r12
  8015b7:	75 0a                	jne    8015c3 <vprintfmt+0x2b7>
				p = "(null)";
  8015b9:	49 bc 2d 53 80 00 00 	movabs $0x80532d,%r12
  8015c0:	00 00 00 
			if (width > 0 && padc != '-')
  8015c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015c7:	7e 3f                	jle    801608 <vprintfmt+0x2fc>
  8015c9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8015cd:	74 39                	je     801608 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015cf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8015d2:	48 98                	cltq   
  8015d4:	48 89 c6             	mov    %rax,%rsi
  8015d7:	4c 89 e7             	mov    %r12,%rdi
  8015da:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8015e1:	00 00 00 
  8015e4:	ff d0                	callq  *%rax
  8015e6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015e9:	eb 17                	jmp    801602 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8015eb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8015ef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8015f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015f7:	48 89 ce             	mov    %rcx,%rsi
  8015fa:	89 d7                	mov    %edx,%edi
  8015fc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015fe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801602:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801606:	7f e3                	jg     8015eb <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801608:	eb 37                	jmp    801641 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80160a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80160e:	74 1e                	je     80162e <vprintfmt+0x322>
  801610:	83 fb 1f             	cmp    $0x1f,%ebx
  801613:	7e 05                	jle    80161a <vprintfmt+0x30e>
  801615:	83 fb 7e             	cmp    $0x7e,%ebx
  801618:	7e 14                	jle    80162e <vprintfmt+0x322>
					putch('?', putdat);
  80161a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80161e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801622:	48 89 d6             	mov    %rdx,%rsi
  801625:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80162a:	ff d0                	callq  *%rax
  80162c:	eb 0f                	jmp    80163d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80162e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801632:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801636:	48 89 d6             	mov    %rdx,%rsi
  801639:	89 df                	mov    %ebx,%edi
  80163b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80163d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801641:	4c 89 e0             	mov    %r12,%rax
  801644:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	0f be d8             	movsbl %al,%ebx
  80164e:	85 db                	test   %ebx,%ebx
  801650:	74 10                	je     801662 <vprintfmt+0x356>
  801652:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801656:	78 b2                	js     80160a <vprintfmt+0x2fe>
  801658:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80165c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801660:	79 a8                	jns    80160a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801662:	eb 16                	jmp    80167a <vprintfmt+0x36e>
				putch(' ', putdat);
  801664:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801668:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80166c:	48 89 d6             	mov    %rdx,%rsi
  80166f:	bf 20 00 00 00       	mov    $0x20,%edi
  801674:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801676:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80167a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80167e:	7f e4                	jg     801664 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801680:	e9 90 01 00 00       	jmpq   801815 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801685:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801689:	be 03 00 00 00       	mov    $0x3,%esi
  80168e:	48 89 c7             	mov    %rax,%rdi
  801691:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  801698:	00 00 00 
  80169b:	ff d0                	callq  *%rax
  80169d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a5:	48 85 c0             	test   %rax,%rax
  8016a8:	79 1d                	jns    8016c7 <vprintfmt+0x3bb>
				putch('-', putdat);
  8016aa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016b2:	48 89 d6             	mov    %rdx,%rsi
  8016b5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016ba:	ff d0                	callq  *%rax
				num = -(long long) num;
  8016bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c0:	48 f7 d8             	neg    %rax
  8016c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8016c7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016ce:	e9 d5 00 00 00       	jmpq   8017a8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8016d3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016d7:	be 03 00 00 00       	mov    $0x3,%esi
  8016dc:	48 89 c7             	mov    %rax,%rdi
  8016df:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  8016e6:	00 00 00 
  8016e9:	ff d0                	callq  *%rax
  8016eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8016ef:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016f6:	e9 ad 00 00 00       	jmpq   8017a8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8016fb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016ff:	be 03 00 00 00       	mov    $0x3,%esi
  801704:	48 89 c7             	mov    %rax,%rdi
  801707:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  80170e:	00 00 00 
  801711:	ff d0                	callq  *%rax
  801713:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801717:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80171e:	e9 85 00 00 00       	jmpq   8017a8 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801723:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801727:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80172b:	48 89 d6             	mov    %rdx,%rsi
  80172e:	bf 30 00 00 00       	mov    $0x30,%edi
  801733:	ff d0                	callq  *%rax
			putch('x', putdat);
  801735:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801739:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80173d:	48 89 d6             	mov    %rdx,%rsi
  801740:	bf 78 00 00 00       	mov    $0x78,%edi
  801745:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801747:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80174a:	83 f8 30             	cmp    $0x30,%eax
  80174d:	73 17                	jae    801766 <vprintfmt+0x45a>
  80174f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801753:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801756:	89 c0                	mov    %eax,%eax
  801758:	48 01 d0             	add    %rdx,%rax
  80175b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80175e:	83 c2 08             	add    $0x8,%edx
  801761:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801764:	eb 0f                	jmp    801775 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801766:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80176a:	48 89 d0             	mov    %rdx,%rax
  80176d:	48 83 c2 08          	add    $0x8,%rdx
  801771:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801775:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801778:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80177c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801783:	eb 23                	jmp    8017a8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801785:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801789:	be 03 00 00 00       	mov    $0x3,%esi
  80178e:	48 89 c7             	mov    %rax,%rdi
  801791:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  801798:	00 00 00 
  80179b:	ff d0                	callq  *%rax
  80179d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8017a1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017a8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8017ad:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8017b0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8017b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8017bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017bf:	45 89 c1             	mov    %r8d,%r9d
  8017c2:	41 89 f8             	mov    %edi,%r8d
  8017c5:	48 89 c7             	mov    %rax,%rdi
  8017c8:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  8017cf:	00 00 00 
  8017d2:	ff d0                	callq  *%rax
			break;
  8017d4:	eb 3f                	jmp    801815 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017de:	48 89 d6             	mov    %rdx,%rsi
  8017e1:	89 df                	mov    %ebx,%edi
  8017e3:	ff d0                	callq  *%rax
			break;
  8017e5:	eb 2e                	jmp    801815 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017ef:	48 89 d6             	mov    %rdx,%rsi
  8017f2:	bf 25 00 00 00       	mov    $0x25,%edi
  8017f7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017f9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017fe:	eb 05                	jmp    801805 <vprintfmt+0x4f9>
  801800:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801805:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801809:	48 83 e8 01          	sub    $0x1,%rax
  80180d:	0f b6 00             	movzbl (%rax),%eax
  801810:	3c 25                	cmp    $0x25,%al
  801812:	75 ec                	jne    801800 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801814:	90                   	nop
		}
	}
  801815:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801816:	e9 43 fb ff ff       	jmpq   80135e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80181b:	48 83 c4 60          	add    $0x60,%rsp
  80181f:	5b                   	pop    %rbx
  801820:	41 5c                	pop    %r12
  801822:	5d                   	pop    %rbp
  801823:	c3                   	retq   

0000000000801824 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80182f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801836:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80183d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801844:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80184b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801852:	84 c0                	test   %al,%al
  801854:	74 20                	je     801876 <printfmt+0x52>
  801856:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80185a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80185e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801862:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801866:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80186a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80186e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801872:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801876:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80187d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801884:	00 00 00 
  801887:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80188e:	00 00 00 
  801891:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801895:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80189c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018a3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8018aa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8018b1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8018b8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8018bf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8018c6:	48 89 c7             	mov    %rax,%rdi
  8018c9:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 10          	sub    $0x10,%rsp
  8018df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8018e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ea:	8b 40 10             	mov    0x10(%rax),%eax
  8018ed:	8d 50 01             	lea    0x1(%rax),%edx
  8018f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8018f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018fb:	48 8b 10             	mov    (%rax),%rdx
  8018fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801902:	48 8b 40 08          	mov    0x8(%rax),%rax
  801906:	48 39 c2             	cmp    %rax,%rdx
  801909:	73 17                	jae    801922 <sprintputch+0x4b>
		*b->buf++ = ch;
  80190b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190f:	48 8b 00             	mov    (%rax),%rax
  801912:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801916:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191a:	48 89 0a             	mov    %rcx,(%rdx)
  80191d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801920:	88 10                	mov    %dl,(%rax)
}
  801922:	c9                   	leaveq 
  801923:	c3                   	retq   

0000000000801924 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 50          	sub    $0x50,%rsp
  80192c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801930:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801933:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801937:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80193b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80193f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801943:	48 8b 0a             	mov    (%rdx),%rcx
  801946:	48 89 08             	mov    %rcx,(%rax)
  801949:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80194d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801951:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801955:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801959:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80195d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801961:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801964:	48 98                	cltq   
  801966:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80196a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80196e:	48 01 d0             	add    %rdx,%rax
  801971:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801975:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80197c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801981:	74 06                	je     801989 <vsnprintf+0x65>
  801983:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801987:	7f 07                	jg     801990 <vsnprintf+0x6c>
		return -E_INVAL;
  801989:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198e:	eb 2f                	jmp    8019bf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801990:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801994:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801998:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80199c:	48 89 c6             	mov    %rax,%rsi
  80199f:	48 bf d7 18 80 00 00 	movabs $0x8018d7,%rdi
  8019a6:	00 00 00 
  8019a9:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  8019b0:	00 00 00 
  8019b3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8019b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8019bc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8019bf:	c9                   	leaveq 
  8019c0:	c3                   	retq   

00000000008019c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019c1:	55                   	push   %rbp
  8019c2:	48 89 e5             	mov    %rsp,%rbp
  8019c5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8019cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8019d3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8019d9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8019e0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8019e7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8019ee:	84 c0                	test   %al,%al
  8019f0:	74 20                	je     801a12 <snprintf+0x51>
  8019f2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8019f6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8019fa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8019fe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a02:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a06:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a0a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a0e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a12:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801a19:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801a20:	00 00 00 
  801a23:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801a2a:	00 00 00 
  801a2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a31:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801a38:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801a3f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a46:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a4d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a54:	48 8b 0a             	mov    (%rdx),%rcx
  801a57:	48 89 08             	mov    %rcx,(%rax)
  801a5a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a5e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a62:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a66:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a6a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a71:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a78:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a7e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a85:	48 89 c7             	mov    %rax,%rdi
  801a88:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	callq  *%rax
  801a94:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801a9a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 18          	sub    $0x18,%rsp
  801aaa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801aae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ab5:	eb 09                	jmp    801ac0 <strlen+0x1e>
		n++;
  801ab7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801abb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac4:	0f b6 00             	movzbl (%rax),%eax
  801ac7:	84 c0                	test   %al,%al
  801ac9:	75 ec                	jne    801ab7 <strlen+0x15>
		n++;
	return n;
  801acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ace:	c9                   	leaveq 
  801acf:	c3                   	retq   

0000000000801ad0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 20          	sub    $0x20,%rsp
  801ad8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801adc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ae7:	eb 0e                	jmp    801af7 <strnlen+0x27>
		n++;
  801ae9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aed:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801af2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801af7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801afc:	74 0b                	je     801b09 <strnlen+0x39>
  801afe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b02:	0f b6 00             	movzbl (%rax),%eax
  801b05:	84 c0                	test   %al,%al
  801b07:	75 e0                	jne    801ae9 <strnlen+0x19>
		n++;
	return n;
  801b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b0c:	c9                   	leaveq 
  801b0d:	c3                   	retq   

0000000000801b0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	48 83 ec 20          	sub    $0x20,%rsp
  801b16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801b1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801b26:	90                   	nop
  801b27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b33:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b37:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801b3b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801b3f:	0f b6 12             	movzbl (%rdx),%edx
  801b42:	88 10                	mov    %dl,(%rax)
  801b44:	0f b6 00             	movzbl (%rax),%eax
  801b47:	84 c0                	test   %al,%al
  801b49:	75 dc                	jne    801b27 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b4f:	c9                   	leaveq 
  801b50:	c3                   	retq   

0000000000801b51 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b51:	55                   	push   %rbp
  801b52:	48 89 e5             	mov    %rsp,%rbp
  801b55:	48 83 ec 20          	sub    $0x20,%rsp
  801b59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b65:	48 89 c7             	mov    %rax,%rdi
  801b68:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	callq  *%rax
  801b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7a:	48 63 d0             	movslq %eax,%rdx
  801b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b81:	48 01 c2             	add    %rax,%rdx
  801b84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b88:	48 89 c6             	mov    %rax,%rsi
  801b8b:	48 89 d7             	mov    %rdx,%rdi
  801b8e:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
	return dst;
  801b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b9e:	c9                   	leaveq 
  801b9f:	c3                   	retq   

0000000000801ba0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ba0:	55                   	push   %rbp
  801ba1:	48 89 e5             	mov    %rsp,%rbp
  801ba4:	48 83 ec 28          	sub    $0x28,%rsp
  801ba8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801bbc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801bc3:	00 
  801bc4:	eb 2a                	jmp    801bf0 <strncpy+0x50>
		*dst++ = *src;
  801bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bd2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801bd6:	0f b6 12             	movzbl (%rdx),%edx
  801bd9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801bdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bdf:	0f b6 00             	movzbl (%rax),%eax
  801be2:	84 c0                	test   %al,%al
  801be4:	74 05                	je     801beb <strncpy+0x4b>
			src++;
  801be6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801beb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801bf8:	72 cc                	jb     801bc6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801bfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 28          	sub    $0x28,%rsp
  801c08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801c1c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c21:	74 3d                	je     801c60 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801c23:	eb 1d                	jmp    801c42 <strlcpy+0x42>
			*dst++ = *src++;
  801c25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c29:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c2d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c31:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c35:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801c39:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801c3d:	0f b6 12             	movzbl (%rdx),%edx
  801c40:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c42:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c47:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c4c:	74 0b                	je     801c59 <strlcpy+0x59>
  801c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c52:	0f b6 00             	movzbl (%rax),%eax
  801c55:	84 c0                	test   %al,%al
  801c57:	75 cc                	jne    801c25 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c68:	48 29 c2             	sub    %rax,%rdx
  801c6b:	48 89 d0             	mov    %rdx,%rax
}
  801c6e:	c9                   	leaveq 
  801c6f:	c3                   	retq   

0000000000801c70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	48 83 ec 10          	sub    $0x10,%rsp
  801c78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c80:	eb 0a                	jmp    801c8c <strcmp+0x1c>
		p++, q++;
  801c82:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c87:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c90:	0f b6 00             	movzbl (%rax),%eax
  801c93:	84 c0                	test   %al,%al
  801c95:	74 12                	je     801ca9 <strcmp+0x39>
  801c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9b:	0f b6 10             	movzbl (%rax),%edx
  801c9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca2:	0f b6 00             	movzbl (%rax),%eax
  801ca5:	38 c2                	cmp    %al,%dl
  801ca7:	74 d9                	je     801c82 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ca9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cad:	0f b6 00             	movzbl (%rax),%eax
  801cb0:	0f b6 d0             	movzbl %al,%edx
  801cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb7:	0f b6 00             	movzbl (%rax),%eax
  801cba:	0f b6 c0             	movzbl %al,%eax
  801cbd:	29 c2                	sub    %eax,%edx
  801cbf:	89 d0                	mov    %edx,%eax
}
  801cc1:	c9                   	leaveq 
  801cc2:	c3                   	retq   

0000000000801cc3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801cc3:	55                   	push   %rbp
  801cc4:	48 89 e5             	mov    %rsp,%rbp
  801cc7:	48 83 ec 18          	sub    $0x18,%rsp
  801ccb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ccf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801cd7:	eb 0f                	jmp    801ce8 <strncmp+0x25>
		n--, p++, q++;
  801cd9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801cde:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ce3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ce8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ced:	74 1d                	je     801d0c <strncmp+0x49>
  801cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf3:	0f b6 00             	movzbl (%rax),%eax
  801cf6:	84 c0                	test   %al,%al
  801cf8:	74 12                	je     801d0c <strncmp+0x49>
  801cfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfe:	0f b6 10             	movzbl (%rax),%edx
  801d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d05:	0f b6 00             	movzbl (%rax),%eax
  801d08:	38 c2                	cmp    %al,%dl
  801d0a:	74 cd                	je     801cd9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d11:	75 07                	jne    801d1a <strncmp+0x57>
		return 0;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	eb 18                	jmp    801d32 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1e:	0f b6 00             	movzbl (%rax),%eax
  801d21:	0f b6 d0             	movzbl %al,%edx
  801d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d28:	0f b6 00             	movzbl (%rax),%eax
  801d2b:	0f b6 c0             	movzbl %al,%eax
  801d2e:	29 c2                	sub    %eax,%edx
  801d30:	89 d0                	mov    %edx,%eax
}
  801d32:	c9                   	leaveq 
  801d33:	c3                   	retq   

0000000000801d34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	48 83 ec 0c          	sub    $0xc,%rsp
  801d3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d40:	89 f0                	mov    %esi,%eax
  801d42:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d45:	eb 17                	jmp    801d5e <strchr+0x2a>
		if (*s == c)
  801d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4b:	0f b6 00             	movzbl (%rax),%eax
  801d4e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d51:	75 06                	jne    801d59 <strchr+0x25>
			return (char *) s;
  801d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d57:	eb 15                	jmp    801d6e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d59:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d62:	0f b6 00             	movzbl (%rax),%eax
  801d65:	84 c0                	test   %al,%al
  801d67:	75 de                	jne    801d47 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 0c          	sub    $0xc,%rsp
  801d78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d7c:	89 f0                	mov    %esi,%eax
  801d7e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d81:	eb 13                	jmp    801d96 <strfind+0x26>
		if (*s == c)
  801d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d87:	0f b6 00             	movzbl (%rax),%eax
  801d8a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d8d:	75 02                	jne    801d91 <strfind+0x21>
			break;
  801d8f:	eb 10                	jmp    801da1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d91:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9a:	0f b6 00             	movzbl (%rax),%eax
  801d9d:	84 c0                	test   %al,%al
  801d9f:	75 e2                	jne    801d83 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801da5:	c9                   	leaveq 
  801da6:	c3                   	retq   

0000000000801da7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801da7:	55                   	push   %rbp
  801da8:	48 89 e5             	mov    %rsp,%rbp
  801dab:	48 83 ec 18          	sub    $0x18,%rsp
  801daf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801db3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801db6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801dba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801dbf:	75 06                	jne    801dc7 <memset+0x20>
		return v;
  801dc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc5:	eb 69                	jmp    801e30 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801dc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcb:	83 e0 03             	and    $0x3,%eax
  801dce:	48 85 c0             	test   %rax,%rax
  801dd1:	75 48                	jne    801e1b <memset+0x74>
  801dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd7:	83 e0 03             	and    $0x3,%eax
  801dda:	48 85 c0             	test   %rax,%rax
  801ddd:	75 3c                	jne    801e1b <memset+0x74>
		c &= 0xFF;
  801ddf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801de6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801de9:	c1 e0 18             	shl    $0x18,%eax
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df1:	c1 e0 10             	shl    $0x10,%eax
  801df4:	09 c2                	or     %eax,%edx
  801df6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df9:	c1 e0 08             	shl    $0x8,%eax
  801dfc:	09 d0                	or     %edx,%eax
  801dfe:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e05:	48 c1 e8 02          	shr    $0x2,%rax
  801e09:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801e0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e10:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e13:	48 89 d7             	mov    %rdx,%rdi
  801e16:	fc                   	cld    
  801e17:	f3 ab                	rep stos %eax,%es:(%rdi)
  801e19:	eb 11                	jmp    801e2c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e1b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e22:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e26:	48 89 d7             	mov    %rdx,%rdi
  801e29:	fc                   	cld    
  801e2a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801e2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801e30:	c9                   	leaveq 
  801e31:	c3                   	retq   

0000000000801e32 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e32:	55                   	push   %rbp
  801e33:	48 89 e5             	mov    %rsp,%rbp
  801e36:	48 83 ec 28          	sub    $0x28,%rsp
  801e3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e42:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e5e:	0f 83 88 00 00 00    	jae    801eec <memmove+0xba>
  801e64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e6c:	48 01 d0             	add    %rdx,%rax
  801e6f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e73:	76 77                	jbe    801eec <memmove+0xba>
		s += n;
  801e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e79:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e81:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e89:	83 e0 03             	and    $0x3,%eax
  801e8c:	48 85 c0             	test   %rax,%rax
  801e8f:	75 3b                	jne    801ecc <memmove+0x9a>
  801e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e95:	83 e0 03             	and    $0x3,%eax
  801e98:	48 85 c0             	test   %rax,%rax
  801e9b:	75 2f                	jne    801ecc <memmove+0x9a>
  801e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea1:	83 e0 03             	and    $0x3,%eax
  801ea4:	48 85 c0             	test   %rax,%rax
  801ea7:	75 23                	jne    801ecc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ead:	48 83 e8 04          	sub    $0x4,%rax
  801eb1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb5:	48 83 ea 04          	sub    $0x4,%rdx
  801eb9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ebd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ec1:	48 89 c7             	mov    %rax,%rdi
  801ec4:	48 89 d6             	mov    %rdx,%rsi
  801ec7:	fd                   	std    
  801ec8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801eca:	eb 1d                	jmp    801ee9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ed4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801edc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee0:	48 89 d7             	mov    %rdx,%rdi
  801ee3:	48 89 c1             	mov    %rax,%rcx
  801ee6:	fd                   	std    
  801ee7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ee9:	fc                   	cld    
  801eea:	eb 57                	jmp    801f43 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801eec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef0:	83 e0 03             	and    $0x3,%eax
  801ef3:	48 85 c0             	test   %rax,%rax
  801ef6:	75 36                	jne    801f2e <memmove+0xfc>
  801ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efc:	83 e0 03             	and    $0x3,%eax
  801eff:	48 85 c0             	test   %rax,%rax
  801f02:	75 2a                	jne    801f2e <memmove+0xfc>
  801f04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f08:	83 e0 03             	and    $0x3,%eax
  801f0b:	48 85 c0             	test   %rax,%rax
  801f0e:	75 1e                	jne    801f2e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f14:	48 c1 e8 02          	shr    $0x2,%rax
  801f18:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f23:	48 89 c7             	mov    %rax,%rdi
  801f26:	48 89 d6             	mov    %rdx,%rsi
  801f29:	fc                   	cld    
  801f2a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f2c:	eb 15                	jmp    801f43 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f36:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801f3a:	48 89 c7             	mov    %rax,%rdi
  801f3d:	48 89 d6             	mov    %rdx,%rsi
  801f40:	fc                   	cld    
  801f41:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f47:	c9                   	leaveq 
  801f48:	c3                   	retq   

0000000000801f49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f49:	55                   	push   %rbp
  801f4a:	48 89 e5             	mov    %rsp,%rbp
  801f4d:	48 83 ec 18          	sub    $0x18,%rsp
  801f51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f59:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f61:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f69:	48 89 ce             	mov    %rcx,%rsi
  801f6c:	48 89 c7             	mov    %rax,%rdi
  801f6f:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	callq  *%rax
}
  801f7b:	c9                   	leaveq 
  801f7c:	c3                   	retq   

0000000000801f7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f7d:	55                   	push   %rbp
  801f7e:	48 89 e5             	mov    %rsp,%rbp
  801f81:	48 83 ec 28          	sub    $0x28,%rsp
  801f85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f8d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801f99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801fa1:	eb 36                	jmp    801fd9 <memcmp+0x5c>
		if (*s1 != *s2)
  801fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa7:	0f b6 10             	movzbl (%rax),%edx
  801faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fae:	0f b6 00             	movzbl (%rax),%eax
  801fb1:	38 c2                	cmp    %al,%dl
  801fb3:	74 1a                	je     801fcf <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb9:	0f b6 00             	movzbl (%rax),%eax
  801fbc:	0f b6 d0             	movzbl %al,%edx
  801fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc3:	0f b6 00             	movzbl (%rax),%eax
  801fc6:	0f b6 c0             	movzbl %al,%eax
  801fc9:	29 c2                	sub    %eax,%edx
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	eb 20                	jmp    801fef <memcmp+0x72>
		s1++, s2++;
  801fcf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801fd4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801fd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801fe1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fe5:	48 85 c0             	test   %rax,%rax
  801fe8:	75 b9                	jne    801fa3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fef:	c9                   	leaveq 
  801ff0:	c3                   	retq   

0000000000801ff1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ff1:	55                   	push   %rbp
  801ff2:	48 89 e5             	mov    %rsp,%rbp
  801ff5:	48 83 ec 28          	sub    $0x28,%rsp
  801ff9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ffd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802000:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802008:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80200c:	48 01 d0             	add    %rdx,%rax
  80200f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802013:	eb 15                	jmp    80202a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802019:	0f b6 10             	movzbl (%rax),%edx
  80201c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80201f:	38 c2                	cmp    %al,%dl
  802021:	75 02                	jne    802025 <memfind+0x34>
			break;
  802023:	eb 0f                	jmp    802034 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802025:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80202a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80202e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802032:	72 e1                	jb     802015 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802038:	c9                   	leaveq 
  802039:	c3                   	retq   

000000000080203a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80203a:	55                   	push   %rbp
  80203b:	48 89 e5             	mov    %rsp,%rbp
  80203e:	48 83 ec 34          	sub    $0x34,%rsp
  802042:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802046:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80204a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80204d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802054:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80205b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80205c:	eb 05                	jmp    802063 <strtol+0x29>
		s++;
  80205e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802063:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802067:	0f b6 00             	movzbl (%rax),%eax
  80206a:	3c 20                	cmp    $0x20,%al
  80206c:	74 f0                	je     80205e <strtol+0x24>
  80206e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802072:	0f b6 00             	movzbl (%rax),%eax
  802075:	3c 09                	cmp    $0x9,%al
  802077:	74 e5                	je     80205e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207d:	0f b6 00             	movzbl (%rax),%eax
  802080:	3c 2b                	cmp    $0x2b,%al
  802082:	75 07                	jne    80208b <strtol+0x51>
		s++;
  802084:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802089:	eb 17                	jmp    8020a2 <strtol+0x68>
	else if (*s == '-')
  80208b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208f:	0f b6 00             	movzbl (%rax),%eax
  802092:	3c 2d                	cmp    $0x2d,%al
  802094:	75 0c                	jne    8020a2 <strtol+0x68>
		s++, neg = 1;
  802096:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80209b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020a6:	74 06                	je     8020ae <strtol+0x74>
  8020a8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8020ac:	75 28                	jne    8020d6 <strtol+0x9c>
  8020ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b2:	0f b6 00             	movzbl (%rax),%eax
  8020b5:	3c 30                	cmp    $0x30,%al
  8020b7:	75 1d                	jne    8020d6 <strtol+0x9c>
  8020b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bd:	48 83 c0 01          	add    $0x1,%rax
  8020c1:	0f b6 00             	movzbl (%rax),%eax
  8020c4:	3c 78                	cmp    $0x78,%al
  8020c6:	75 0e                	jne    8020d6 <strtol+0x9c>
		s += 2, base = 16;
  8020c8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8020cd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8020d4:	eb 2c                	jmp    802102 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8020d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020da:	75 19                	jne    8020f5 <strtol+0xbb>
  8020dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e0:	0f b6 00             	movzbl (%rax),%eax
  8020e3:	3c 30                	cmp    $0x30,%al
  8020e5:	75 0e                	jne    8020f5 <strtol+0xbb>
		s++, base = 8;
  8020e7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020ec:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8020f3:	eb 0d                	jmp    802102 <strtol+0xc8>
	else if (base == 0)
  8020f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020f9:	75 07                	jne    802102 <strtol+0xc8>
		base = 10;
  8020fb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802102:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802106:	0f b6 00             	movzbl (%rax),%eax
  802109:	3c 2f                	cmp    $0x2f,%al
  80210b:	7e 1d                	jle    80212a <strtol+0xf0>
  80210d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802111:	0f b6 00             	movzbl (%rax),%eax
  802114:	3c 39                	cmp    $0x39,%al
  802116:	7f 12                	jg     80212a <strtol+0xf0>
			dig = *s - '0';
  802118:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211c:	0f b6 00             	movzbl (%rax),%eax
  80211f:	0f be c0             	movsbl %al,%eax
  802122:	83 e8 30             	sub    $0x30,%eax
  802125:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802128:	eb 4e                	jmp    802178 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80212a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212e:	0f b6 00             	movzbl (%rax),%eax
  802131:	3c 60                	cmp    $0x60,%al
  802133:	7e 1d                	jle    802152 <strtol+0x118>
  802135:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802139:	0f b6 00             	movzbl (%rax),%eax
  80213c:	3c 7a                	cmp    $0x7a,%al
  80213e:	7f 12                	jg     802152 <strtol+0x118>
			dig = *s - 'a' + 10;
  802140:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802144:	0f b6 00             	movzbl (%rax),%eax
  802147:	0f be c0             	movsbl %al,%eax
  80214a:	83 e8 57             	sub    $0x57,%eax
  80214d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802150:	eb 26                	jmp    802178 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802152:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802156:	0f b6 00             	movzbl (%rax),%eax
  802159:	3c 40                	cmp    $0x40,%al
  80215b:	7e 48                	jle    8021a5 <strtol+0x16b>
  80215d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802161:	0f b6 00             	movzbl (%rax),%eax
  802164:	3c 5a                	cmp    $0x5a,%al
  802166:	7f 3d                	jg     8021a5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216c:	0f b6 00             	movzbl (%rax),%eax
  80216f:	0f be c0             	movsbl %al,%eax
  802172:	83 e8 37             	sub    $0x37,%eax
  802175:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802178:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80217e:	7c 02                	jl     802182 <strtol+0x148>
			break;
  802180:	eb 23                	jmp    8021a5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  802182:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802187:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80218a:	48 98                	cltq   
  80218c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802191:	48 89 c2             	mov    %rax,%rdx
  802194:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802197:	48 98                	cltq   
  802199:	48 01 d0             	add    %rdx,%rax
  80219c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8021a0:	e9 5d ff ff ff       	jmpq   802102 <strtol+0xc8>

	if (endptr)
  8021a5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8021aa:	74 0b                	je     8021b7 <strtol+0x17d>
		*endptr = (char *) s;
  8021ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021b4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8021b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021bb:	74 09                	je     8021c6 <strtol+0x18c>
  8021bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c1:	48 f7 d8             	neg    %rax
  8021c4:	eb 04                	jmp    8021ca <strtol+0x190>
  8021c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8021ca:	c9                   	leaveq 
  8021cb:	c3                   	retq   

00000000008021cc <strstr>:

char * strstr(const char *in, const char *str)
{
  8021cc:	55                   	push   %rbp
  8021cd:	48 89 e5             	mov    %rsp,%rbp
  8021d0:	48 83 ec 30          	sub    $0x30,%rsp
  8021d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8021dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021e4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8021e8:	0f b6 00             	movzbl (%rax),%eax
  8021eb:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8021ee:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8021f2:	75 06                	jne    8021fa <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8021f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f8:	eb 6b                	jmp    802265 <strstr+0x99>

	len = strlen(str);
  8021fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021fe:	48 89 c7             	mov    %rax,%rdi
  802201:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  802208:	00 00 00 
  80220b:	ff d0                	callq  *%rax
  80220d:	48 98                	cltq   
  80220f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802213:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802217:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80221b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80221f:	0f b6 00             	movzbl (%rax),%eax
  802222:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802225:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802229:	75 07                	jne    802232 <strstr+0x66>
				return (char *) 0;
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	eb 33                	jmp    802265 <strstr+0x99>
		} while (sc != c);
  802232:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802236:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802239:	75 d8                	jne    802213 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80223b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802247:	48 89 ce             	mov    %rcx,%rsi
  80224a:	48 89 c7             	mov    %rax,%rdi
  80224d:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
  802259:	85 c0                	test   %eax,%eax
  80225b:	75 b6                	jne    802213 <strstr+0x47>

	return (char *) (in - 1);
  80225d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802261:	48 83 e8 01          	sub    $0x1,%rax
}
  802265:	c9                   	leaveq 
  802266:	c3                   	retq   

0000000000802267 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802267:	55                   	push   %rbp
  802268:	48 89 e5             	mov    %rsp,%rbp
  80226b:	53                   	push   %rbx
  80226c:	48 83 ec 48          	sub    $0x48,%rsp
  802270:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802273:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802276:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80227a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80227e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802282:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802286:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802289:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80228d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802291:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802295:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802299:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80229d:	4c 89 c3             	mov    %r8,%rbx
  8022a0:	cd 30                	int    $0x30
  8022a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8022a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8022aa:	74 3e                	je     8022ea <syscall+0x83>
  8022ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022b1:	7e 37                	jle    8022ea <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8022b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ba:	49 89 d0             	mov    %rdx,%r8
  8022bd:	89 c1                	mov    %eax,%ecx
  8022bf:	48 ba e8 55 80 00 00 	movabs $0x8055e8,%rdx
  8022c6:	00 00 00 
  8022c9:	be 24 00 00 00       	mov    $0x24,%esi
  8022ce:	48 bf 05 56 80 00 00 	movabs $0x805605,%rdi
  8022d5:	00 00 00 
  8022d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dd:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  8022e4:	00 00 00 
  8022e7:	41 ff d1             	callq  *%r9

	return ret;
  8022ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022ee:	48 83 c4 48          	add    $0x48,%rsp
  8022f2:	5b                   	pop    %rbx
  8022f3:	5d                   	pop    %rbp
  8022f4:	c3                   	retq   

00000000008022f5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8022f5:	55                   	push   %rbp
  8022f6:	48 89 e5             	mov    %rsp,%rbp
  8022f9:	48 83 ec 20          	sub    $0x20,%rsp
  8022fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802301:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802309:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802314:	00 
  802315:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80231b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802321:	48 89 d1             	mov    %rdx,%rcx
  802324:	48 89 c2             	mov    %rax,%rdx
  802327:	be 00 00 00 00       	mov    $0x0,%esi
  80232c:	bf 00 00 00 00       	mov    $0x0,%edi
  802331:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802338:	00 00 00 
  80233b:	ff d0                	callq  *%rax
}
  80233d:	c9                   	leaveq 
  80233e:	c3                   	retq   

000000000080233f <sys_cgetc>:

int
sys_cgetc(void)
{
  80233f:	55                   	push   %rbp
  802340:	48 89 e5             	mov    %rsp,%rbp
  802343:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802347:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80234e:	00 
  80234f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802355:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80235b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802360:	ba 00 00 00 00       	mov    $0x0,%edx
  802365:	be 00 00 00 00       	mov    $0x0,%esi
  80236a:	bf 01 00 00 00       	mov    $0x1,%edi
  80236f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802376:	00 00 00 
  802379:	ff d0                	callq  *%rax
}
  80237b:	c9                   	leaveq 
  80237c:	c3                   	retq   

000000000080237d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80237d:	55                   	push   %rbp
  80237e:	48 89 e5             	mov    %rsp,%rbp
  802381:	48 83 ec 10          	sub    $0x10,%rsp
  802385:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802388:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238b:	48 98                	cltq   
  80238d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802394:	00 
  802395:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80239b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023a6:	48 89 c2             	mov    %rax,%rdx
  8023a9:	be 01 00 00 00       	mov    $0x1,%esi
  8023ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8023b3:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
}
  8023bf:	c9                   	leaveq 
  8023c0:	c3                   	retq   

00000000008023c1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8023c1:	55                   	push   %rbp
  8023c2:	48 89 e5             	mov    %rsp,%rbp
  8023c5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8023c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023d0:	00 
  8023d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e7:	be 00 00 00 00       	mov    $0x0,%esi
  8023ec:	bf 02 00 00 00       	mov    $0x2,%edi
  8023f1:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
}
  8023fd:	c9                   	leaveq 
  8023fe:	c3                   	retq   

00000000008023ff <sys_yield>:


void
sys_yield(void)
{
  8023ff:	55                   	push   %rbp
  802400:	48 89 e5             	mov    %rsp,%rbp
  802403:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802407:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80240e:	00 
  80240f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802415:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80241b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802420:	ba 00 00 00 00       	mov    $0x0,%edx
  802425:	be 00 00 00 00       	mov    $0x0,%esi
  80242a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80242f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802436:	00 00 00 
  802439:	ff d0                	callq  *%rax
}
  80243b:	c9                   	leaveq 
  80243c:	c3                   	retq   

000000000080243d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80243d:	55                   	push   %rbp
  80243e:	48 89 e5             	mov    %rsp,%rbp
  802441:	48 83 ec 20          	sub    $0x20,%rsp
  802445:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802448:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80244c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80244f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802452:	48 63 c8             	movslq %eax,%rcx
  802455:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245c:	48 98                	cltq   
  80245e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802465:	00 
  802466:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80246c:	49 89 c8             	mov    %rcx,%r8
  80246f:	48 89 d1             	mov    %rdx,%rcx
  802472:	48 89 c2             	mov    %rax,%rdx
  802475:	be 01 00 00 00       	mov    $0x1,%esi
  80247a:	bf 04 00 00 00       	mov    $0x4,%edi
  80247f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802486:	00 00 00 
  802489:	ff d0                	callq  *%rax
}
  80248b:	c9                   	leaveq 
  80248c:	c3                   	retq   

000000000080248d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80248d:	55                   	push   %rbp
  80248e:	48 89 e5             	mov    %rsp,%rbp
  802491:	48 83 ec 30          	sub    $0x30,%rsp
  802495:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80249c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80249f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024a3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8024a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024aa:	48 63 c8             	movslq %eax,%rcx
  8024ad:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8024b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b4:	48 63 f0             	movslq %eax,%rsi
  8024b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024be:	48 98                	cltq   
  8024c0:	48 89 0c 24          	mov    %rcx,(%rsp)
  8024c4:	49 89 f9             	mov    %rdi,%r9
  8024c7:	49 89 f0             	mov    %rsi,%r8
  8024ca:	48 89 d1             	mov    %rdx,%rcx
  8024cd:	48 89 c2             	mov    %rax,%rdx
  8024d0:	be 01 00 00 00       	mov    $0x1,%esi
  8024d5:	bf 05 00 00 00       	mov    $0x5,%edi
  8024da:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8024e1:	00 00 00 
  8024e4:	ff d0                	callq  *%rax
}
  8024e6:	c9                   	leaveq 
  8024e7:	c3                   	retq   

00000000008024e8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8024e8:	55                   	push   %rbp
  8024e9:	48 89 e5             	mov    %rsp,%rbp
  8024ec:	48 83 ec 20          	sub    $0x20,%rsp
  8024f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8024f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fe:	48 98                	cltq   
  802500:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802507:	00 
  802508:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80250e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802514:	48 89 d1             	mov    %rdx,%rcx
  802517:	48 89 c2             	mov    %rax,%rdx
  80251a:	be 01 00 00 00       	mov    $0x1,%esi
  80251f:	bf 06 00 00 00       	mov    $0x6,%edi
  802524:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  80252b:	00 00 00 
  80252e:	ff d0                	callq  *%rax
}
  802530:	c9                   	leaveq 
  802531:	c3                   	retq   

0000000000802532 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802532:	55                   	push   %rbp
  802533:	48 89 e5             	mov    %rsp,%rbp
  802536:	48 83 ec 10          	sub    $0x10,%rsp
  80253a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80253d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802540:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802543:	48 63 d0             	movslq %eax,%rdx
  802546:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802549:	48 98                	cltq   
  80254b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802552:	00 
  802553:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802559:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80255f:	48 89 d1             	mov    %rdx,%rcx
  802562:	48 89 c2             	mov    %rax,%rdx
  802565:	be 01 00 00 00       	mov    $0x1,%esi
  80256a:	bf 08 00 00 00       	mov    $0x8,%edi
  80256f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802576:	00 00 00 
  802579:	ff d0                	callq  *%rax
}
  80257b:	c9                   	leaveq 
  80257c:	c3                   	retq   

000000000080257d <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80257d:	55                   	push   %rbp
  80257e:	48 89 e5             	mov    %rsp,%rbp
  802581:	48 83 ec 20          	sub    $0x20,%rsp
  802585:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802588:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80258c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802593:	48 98                	cltq   
  802595:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80259c:	00 
  80259d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025a9:	48 89 d1             	mov    %rdx,%rcx
  8025ac:	48 89 c2             	mov    %rax,%rdx
  8025af:	be 01 00 00 00       	mov    $0x1,%esi
  8025b4:	bf 09 00 00 00       	mov    $0x9,%edi
  8025b9:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
}
  8025c5:	c9                   	leaveq 
  8025c6:	c3                   	retq   

00000000008025c7 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8025c7:	55                   	push   %rbp
  8025c8:	48 89 e5             	mov    %rsp,%rbp
  8025cb:	48 83 ec 20          	sub    $0x20,%rsp
  8025cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8025d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025dd:	48 98                	cltq   
  8025df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025e6:	00 
  8025e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025f3:	48 89 d1             	mov    %rdx,%rcx
  8025f6:	48 89 c2             	mov    %rax,%rdx
  8025f9:	be 01 00 00 00       	mov    $0x1,%esi
  8025fe:	bf 0a 00 00 00       	mov    $0xa,%edi
  802603:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  80260a:	00 00 00 
  80260d:	ff d0                	callq  *%rax
}
  80260f:	c9                   	leaveq 
  802610:	c3                   	retq   

0000000000802611 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	48 83 ec 20          	sub    $0x20,%rsp
  802619:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80261c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802620:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802624:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802627:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80262a:	48 63 f0             	movslq %eax,%rsi
  80262d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802634:	48 98                	cltq   
  802636:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80263a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802641:	00 
  802642:	49 89 f1             	mov    %rsi,%r9
  802645:	49 89 c8             	mov    %rcx,%r8
  802648:	48 89 d1             	mov    %rdx,%rcx
  80264b:	48 89 c2             	mov    %rax,%rdx
  80264e:	be 00 00 00 00       	mov    $0x0,%esi
  802653:	bf 0c 00 00 00       	mov    $0xc,%edi
  802658:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  80265f:	00 00 00 
  802662:	ff d0                	callq  *%rax
}
  802664:	c9                   	leaveq 
  802665:	c3                   	retq   

0000000000802666 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802666:	55                   	push   %rbp
  802667:	48 89 e5             	mov    %rsp,%rbp
  80266a:	48 83 ec 10          	sub    $0x10,%rsp
  80266e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802676:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80267d:	00 
  80267e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802684:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80268a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80268f:	48 89 c2             	mov    %rax,%rdx
  802692:	be 01 00 00 00       	mov    $0x1,%esi
  802697:	bf 0d 00 00 00       	mov    $0xd,%edi
  80269c:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax
}
  8026a8:	c9                   	leaveq 
  8026a9:	c3                   	retq   

00000000008026aa <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8026aa:	55                   	push   %rbp
  8026ab:	48 89 e5             	mov    %rsp,%rbp
  8026ae:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8026b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8026b9:	00 
  8026ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d0:	be 00 00 00 00       	mov    $0x0,%esi
  8026d5:	bf 0e 00 00 00       	mov    $0xe,%edi
  8026da:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 20          	sub    $0x20,%rsp
  8026f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026f4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8026f7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8026fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802705:	00 
  802706:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80270c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802712:	48 89 d1             	mov    %rdx,%rcx
  802715:	48 89 c2             	mov    %rax,%rdx
  802718:	be 00 00 00 00       	mov    $0x0,%esi
  80271d:	bf 0f 00 00 00       	mov    $0xf,%edi
  802722:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802729:	00 00 00 
  80272c:	ff d0                	callq  *%rax
}
  80272e:	c9                   	leaveq 
  80272f:	c3                   	retq   

0000000000802730 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802730:	55                   	push   %rbp
  802731:	48 89 e5             	mov    %rsp,%rbp
  802734:	48 83 ec 20          	sub    $0x20,%rsp
  802738:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80273c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  80273f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802746:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80274d:	00 
  80274e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802754:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80275a:	48 89 d1             	mov    %rdx,%rcx
  80275d:	48 89 c2             	mov    %rax,%rdx
  802760:	be 00 00 00 00       	mov    $0x0,%esi
  802765:	bf 10 00 00 00       	mov    $0x10,%edi
  80276a:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
}
  802776:	c9                   	leaveq 
  802777:	c3                   	retq   

0000000000802778 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802778:	55                   	push   %rbp
  802779:	48 89 e5             	mov    %rsp,%rbp
  80277c:	48 83 ec 30          	sub    $0x30,%rsp
  802780:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802783:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802787:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80278a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80278e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802792:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802795:	48 63 c8             	movslq %eax,%rcx
  802798:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80279c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80279f:	48 63 f0             	movslq %eax,%rsi
  8027a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a9:	48 98                	cltq   
  8027ab:	48 89 0c 24          	mov    %rcx,(%rsp)
  8027af:	49 89 f9             	mov    %rdi,%r9
  8027b2:	49 89 f0             	mov    %rsi,%r8
  8027b5:	48 89 d1             	mov    %rdx,%rcx
  8027b8:	48 89 c2             	mov    %rax,%rdx
  8027bb:	be 00 00 00 00       	mov    $0x0,%esi
  8027c0:	bf 11 00 00 00       	mov    $0x11,%edi
  8027c5:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8027d1:	c9                   	leaveq 
  8027d2:	c3                   	retq   

00000000008027d3 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8027d3:	55                   	push   %rbp
  8027d4:	48 89 e5             	mov    %rsp,%rbp
  8027d7:	48 83 ec 20          	sub    $0x20,%rsp
  8027db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8027e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8027f2:	00 
  8027f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027ff:	48 89 d1             	mov    %rdx,%rcx
  802802:	48 89 c2             	mov    %rax,%rdx
  802805:	be 00 00 00 00       	mov    $0x0,%esi
  80280a:	bf 12 00 00 00       	mov    $0x12,%edi
  80280f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802816:	00 00 00 
  802819:	ff d0                	callq  *%rax
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 30          	sub    $0x30,%rsp
  802825:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802829:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80282d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802831:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802836:	75 0e                	jne    802846 <ipc_recv+0x29>
		pg = (void*) UTOP;
  802838:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80283f:	00 00 00 
  802842:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802846:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284a:	48 89 c7             	mov    %rax,%rdi
  80284d:	48 b8 66 26 80 00 00 	movabs $0x802666,%rax
  802854:	00 00 00 
  802857:	ff d0                	callq  *%rax
  802859:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802860:	79 27                	jns    802889 <ipc_recv+0x6c>
		if (from_env_store)
  802862:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802867:	74 0a                	je     802873 <ipc_recv+0x56>
			*from_env_store = 0;
  802869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802873:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802878:	74 0a                	je     802884 <ipc_recv+0x67>
			*perm_store = 0;
  80287a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80287e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802887:	eb 53                	jmp    8028dc <ipc_recv+0xbf>
	}
	if (from_env_store)
  802889:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80288e:	74 19                	je     8028a9 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  802890:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802897:	00 00 00 
  80289a:	48 8b 00             	mov    (%rax),%rax
  80289d:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8028a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a7:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8028a9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028ae:	74 19                	je     8028c9 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8028b0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8028b7:	00 00 00 
  8028ba:	48 8b 00             	mov    (%rax),%rax
  8028bd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8028c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c7:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8028c9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8028d0:	00 00 00 
  8028d3:	48 8b 00             	mov    (%rax),%rax
  8028d6:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8028dc:	c9                   	leaveq 
  8028dd:	c3                   	retq   

00000000008028de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028de:	55                   	push   %rbp
  8028df:	48 89 e5             	mov    %rsp,%rbp
  8028e2:	48 83 ec 30          	sub    $0x30,%rsp
  8028e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028e9:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8028ec:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8028f0:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8028f3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028f8:	75 10                	jne    80290a <ipc_send+0x2c>
		pg = (void*) UTOP;
  8028fa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802901:	00 00 00 
  802904:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802908:	eb 0e                	jmp    802918 <ipc_send+0x3a>
  80290a:	eb 0c                	jmp    802918 <ipc_send+0x3a>
		sys_yield();
  80290c:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802913:	00 00 00 
  802916:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802918:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80291b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80291e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802922:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802925:	89 c7                	mov    %eax,%edi
  802927:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
  802933:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802936:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80293a:	74 d0                	je     80290c <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  80293c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802940:	79 30                	jns    802972 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  802942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802945:	89 c1                	mov    %eax,%ecx
  802947:	48 ba 13 56 80 00 00 	movabs $0x805613,%rdx
  80294e:	00 00 00 
  802951:	be 47 00 00 00       	mov    $0x47,%esi
  802956:	48 bf 29 56 80 00 00 	movabs $0x805629,%rdi
  80295d:	00 00 00 
  802960:	b8 00 00 00 00       	mov    $0x0,%eax
  802965:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80296c:	00 00 00 
  80296f:	41 ff d0             	callq  *%r8

}
  802972:	c9                   	leaveq 
  802973:	c3                   	retq   

0000000000802974 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802974:	55                   	push   %rbp
  802975:	48 89 e5             	mov    %rsp,%rbp
  802978:	53                   	push   %rbx
  802979:	48 83 ec 28          	sub    $0x28,%rsp
  80297d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  802981:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802988:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  80298f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802994:	75 0e                	jne    8029a4 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  802996:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80299d:	00 00 00 
  8029a0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8029a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a8:	ba 07 00 00 00       	mov    $0x7,%edx
  8029ad:	48 89 c6             	mov    %rax,%rsi
  8029b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b5:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  8029bc:	00 00 00 
  8029bf:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8029c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c5:	48 c1 e8 0c          	shr    $0xc,%rax
  8029c9:	48 89 c2             	mov    %rax,%rdx
  8029cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029d3:	01 00 00 
  8029d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029da:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8029e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  8029e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8029e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029ed:	48 89 d3             	mov    %rdx,%rbx
  8029f0:	0f 01 c1             	vmcall 
  8029f3:	89 f2                	mov    %esi,%edx
  8029f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029f8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  8029fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029ff:	79 05                	jns    802a06 <ipc_host_recv+0x92>
		return r;
  802a01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a04:	eb 03                	jmp    802a09 <ipc_host_recv+0x95>
	}
	return val;
  802a06:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  802a09:	48 83 c4 28          	add    $0x28,%rsp
  802a0d:	5b                   	pop    %rbx
  802a0e:	5d                   	pop    %rbp
  802a0f:	c3                   	retq   

0000000000802a10 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a10:	55                   	push   %rbp
  802a11:	48 89 e5             	mov    %rsp,%rbp
  802a14:	53                   	push   %rbx
  802a15:	48 83 ec 38          	sub    $0x38,%rsp
  802a19:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a1c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802a1f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802a23:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  802a26:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  802a2d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802a32:	75 0e                	jne    802a42 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802a34:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802a3b:	00 00 00 
  802a3e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802a42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a46:	48 c1 e8 0c          	shr    $0xc,%rax
  802a4a:	48 89 c2             	mov    %rax,%rdx
  802a4d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a54:	01 00 00 
  802a57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a5b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802a61:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802a65:	b8 02 00 00 00       	mov    $0x2,%eax
  802a6a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802a6d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a70:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a74:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802a77:	89 fb                	mov    %edi,%ebx
  802a79:	0f 01 c1             	vmcall 
  802a7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802a7f:	eb 26                	jmp    802aa7 <ipc_host_send+0x97>
		sys_yield();
  802a81:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802a88:	00 00 00 
  802a8b:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802a8d:	b8 02 00 00 00       	mov    $0x2,%eax
  802a92:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802a95:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a98:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a9c:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802a9f:	89 fb                	mov    %edi,%ebx
  802aa1:	0f 01 c1             	vmcall 
  802aa4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802aa7:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  802aab:	74 d4                	je     802a81 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  802aad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ab1:	79 30                	jns    802ae3 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  802ab3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ab6:	89 c1                	mov    %eax,%ecx
  802ab8:	48 ba 13 56 80 00 00 	movabs $0x805613,%rdx
  802abf:	00 00 00 
  802ac2:	be 79 00 00 00       	mov    $0x79,%esi
  802ac7:	48 bf 29 56 80 00 00 	movabs $0x805629,%rdi
  802ace:	00 00 00 
  802ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad6:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  802add:	00 00 00 
  802ae0:	41 ff d0             	callq  *%r8

}
  802ae3:	48 83 c4 38          	add    $0x38,%rsp
  802ae7:	5b                   	pop    %rbx
  802ae8:	5d                   	pop    %rbp
  802ae9:	c3                   	retq   

0000000000802aea <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802aea:	55                   	push   %rbp
  802aeb:	48 89 e5             	mov    %rsp,%rbp
  802aee:	48 83 ec 14          	sub    $0x14,%rsp
  802af2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802af5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802afc:	eb 4e                	jmp    802b4c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802afe:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802b05:	00 00 00 
  802b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0b:	48 98                	cltq   
  802b0d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802b14:	48 01 d0             	add    %rdx,%rax
  802b17:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802b1d:	8b 00                	mov    (%rax),%eax
  802b1f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b22:	75 24                	jne    802b48 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802b24:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802b2b:	00 00 00 
  802b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b31:	48 98                	cltq   
  802b33:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802b3a:	48 01 d0             	add    %rdx,%rax
  802b3d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802b43:	8b 40 08             	mov    0x8(%rax),%eax
  802b46:	eb 12                	jmp    802b5a <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802b48:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b4c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802b53:	7e a9                	jle    802afe <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5a:	c9                   	leaveq 
  802b5b:	c3                   	retq   

0000000000802b5c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802b5c:	55                   	push   %rbp
  802b5d:	48 89 e5             	mov    %rsp,%rbp
  802b60:	48 83 ec 08          	sub    $0x8,%rsp
  802b64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b6c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802b73:	ff ff ff 
  802b76:	48 01 d0             	add    %rdx,%rax
  802b79:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802b7d:	c9                   	leaveq 
  802b7e:	c3                   	retq   

0000000000802b7f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802b7f:	55                   	push   %rbp
  802b80:	48 89 e5             	mov    %rsp,%rbp
  802b83:	48 83 ec 08          	sub    $0x8,%rsp
  802b87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b8f:	48 89 c7             	mov    %rax,%rdi
  802b92:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
  802b9e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802ba4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802ba8:	c9                   	leaveq 
  802ba9:	c3                   	retq   

0000000000802baa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802baa:	55                   	push   %rbp
  802bab:	48 89 e5             	mov    %rsp,%rbp
  802bae:	48 83 ec 18          	sub    $0x18,%rsp
  802bb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bbd:	eb 6b                	jmp    802c2a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc2:	48 98                	cltq   
  802bc4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bca:	48 c1 e0 0c          	shl    $0xc,%rax
  802bce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd6:	48 c1 e8 15          	shr    $0x15,%rax
  802bda:	48 89 c2             	mov    %rax,%rdx
  802bdd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802be4:	01 00 00 
  802be7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802beb:	83 e0 01             	and    $0x1,%eax
  802bee:	48 85 c0             	test   %rax,%rax
  802bf1:	74 21                	je     802c14 <fd_alloc+0x6a>
  802bf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf7:	48 c1 e8 0c          	shr    $0xc,%rax
  802bfb:	48 89 c2             	mov    %rax,%rdx
  802bfe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c05:	01 00 00 
  802c08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c0c:	83 e0 01             	and    $0x1,%eax
  802c0f:	48 85 c0             	test   %rax,%rax
  802c12:	75 12                	jne    802c26 <fd_alloc+0x7c>
			*fd_store = fd;
  802c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c1c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c24:	eb 1a                	jmp    802c40 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802c26:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c2a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c2e:	7e 8f                	jle    802bbf <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c34:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802c3b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802c40:	c9                   	leaveq 
  802c41:	c3                   	retq   

0000000000802c42 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802c42:	55                   	push   %rbp
  802c43:	48 89 e5             	mov    %rsp,%rbp
  802c46:	48 83 ec 20          	sub    $0x20,%rsp
  802c4a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802c51:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c55:	78 06                	js     802c5d <fd_lookup+0x1b>
  802c57:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802c5b:	7e 07                	jle    802c64 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c62:	eb 6c                	jmp    802cd0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802c64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c67:	48 98                	cltq   
  802c69:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c6f:	48 c1 e0 0c          	shl    $0xc,%rax
  802c73:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c7b:	48 c1 e8 15          	shr    $0x15,%rax
  802c7f:	48 89 c2             	mov    %rax,%rdx
  802c82:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c89:	01 00 00 
  802c8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c90:	83 e0 01             	and    $0x1,%eax
  802c93:	48 85 c0             	test   %rax,%rax
  802c96:	74 21                	je     802cb9 <fd_lookup+0x77>
  802c98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9c:	48 c1 e8 0c          	shr    $0xc,%rax
  802ca0:	48 89 c2             	mov    %rax,%rdx
  802ca3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802caa:	01 00 00 
  802cad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cb1:	83 e0 01             	and    $0x1,%eax
  802cb4:	48 85 c0             	test   %rax,%rax
  802cb7:	75 07                	jne    802cc0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802cb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cbe:	eb 10                	jmp    802cd0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802cc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802cc8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cd0:	c9                   	leaveq 
  802cd1:	c3                   	retq   

0000000000802cd2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802cd2:	55                   	push   %rbp
  802cd3:	48 89 e5             	mov    %rsp,%rbp
  802cd6:	48 83 ec 30          	sub    $0x30,%rsp
  802cda:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cde:	89 f0                	mov    %esi,%eax
  802ce0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ce3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ce7:	48 89 c7             	mov    %rax,%rdi
  802cea:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
  802cf6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cfa:	48 89 d6             	mov    %rdx,%rsi
  802cfd:	89 c7                	mov    %eax,%edi
  802cff:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  802d06:	00 00 00 
  802d09:	ff d0                	callq  *%rax
  802d0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d12:	78 0a                	js     802d1e <fd_close+0x4c>
	    || fd != fd2)
  802d14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d18:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802d1c:	74 12                	je     802d30 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802d1e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802d22:	74 05                	je     802d29 <fd_close+0x57>
  802d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d27:	eb 05                	jmp    802d2e <fd_close+0x5c>
  802d29:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2e:	eb 69                	jmp    802d99 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802d30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d34:	8b 00                	mov    (%rax),%eax
  802d36:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3a:	48 89 d6             	mov    %rdx,%rsi
  802d3d:	89 c7                	mov    %eax,%edi
  802d3f:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d52:	78 2a                	js     802d7e <fd_close+0xac>
		if (dev->dev_close)
  802d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d58:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d5c:	48 85 c0             	test   %rax,%rax
  802d5f:	74 16                	je     802d77 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802d61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d65:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d69:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d6d:	48 89 d7             	mov    %rdx,%rdi
  802d70:	ff d0                	callq  *%rax
  802d72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d75:	eb 07                	jmp    802d7e <fd_close+0xac>
		else
			r = 0;
  802d77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802d7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d82:	48 89 c6             	mov    %rax,%rsi
  802d85:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8a:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
	return r;
  802d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d99:	c9                   	leaveq 
  802d9a:	c3                   	retq   

0000000000802d9b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d9b:	55                   	push   %rbp
  802d9c:	48 89 e5             	mov    %rsp,%rbp
  802d9f:	48 83 ec 20          	sub    $0x20,%rsp
  802da3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802da6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802daa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802db1:	eb 41                	jmp    802df4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802db3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802dba:	00 00 00 
  802dbd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802dc0:	48 63 d2             	movslq %edx,%rdx
  802dc3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dc7:	8b 00                	mov    (%rax),%eax
  802dc9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802dcc:	75 22                	jne    802df0 <dev_lookup+0x55>
			*dev = devtab[i];
  802dce:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802dd5:	00 00 00 
  802dd8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ddb:	48 63 d2             	movslq %edx,%rdx
  802dde:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802de2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802de9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dee:	eb 60                	jmp    802e50 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802df0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802df4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802dfb:	00 00 00 
  802dfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e01:	48 63 d2             	movslq %edx,%rdx
  802e04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e08:	48 85 c0             	test   %rax,%rax
  802e0b:	75 a6                	jne    802db3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802e0d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e14:	00 00 00 
  802e17:	48 8b 00             	mov    (%rax),%rax
  802e1a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e20:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e23:	89 c6                	mov    %eax,%esi
  802e25:	48 bf 38 56 80 00 00 	movabs $0x805638,%rdi
  802e2c:	00 00 00 
  802e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e34:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  802e3b:	00 00 00 
  802e3e:	ff d1                	callq  *%rcx
	*dev = 0;
  802e40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e44:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802e4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802e50:	c9                   	leaveq 
  802e51:	c3                   	retq   

0000000000802e52 <close>:

int
close(int fdnum)
{
  802e52:	55                   	push   %rbp
  802e53:	48 89 e5             	mov    %rsp,%rbp
  802e56:	48 83 ec 20          	sub    $0x20,%rsp
  802e5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e64:	48 89 d6             	mov    %rdx,%rsi
  802e67:	89 c7                	mov    %eax,%edi
  802e69:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  802e70:	00 00 00 
  802e73:	ff d0                	callq  *%rax
  802e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7c:	79 05                	jns    802e83 <close+0x31>
		return r;
  802e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e81:	eb 18                	jmp    802e9b <close+0x49>
	else
		return fd_close(fd, 1);
  802e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e87:	be 01 00 00 00       	mov    $0x1,%esi
  802e8c:	48 89 c7             	mov    %rax,%rdi
  802e8f:	48 b8 d2 2c 80 00 00 	movabs $0x802cd2,%rax
  802e96:	00 00 00 
  802e99:	ff d0                	callq  *%rax
}
  802e9b:	c9                   	leaveq 
  802e9c:	c3                   	retq   

0000000000802e9d <close_all>:

void
close_all(void)
{
  802e9d:	55                   	push   %rbp
  802e9e:	48 89 e5             	mov    %rsp,%rbp
  802ea1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802ea5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802eac:	eb 15                	jmp    802ec3 <close_all+0x26>
		close(i);
  802eae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802ebf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ec3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802ec7:	7e e5                	jle    802eae <close_all+0x11>
		close(i);
}
  802ec9:	c9                   	leaveq 
  802eca:	c3                   	retq   

0000000000802ecb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802ecb:	55                   	push   %rbp
  802ecc:	48 89 e5             	mov    %rsp,%rbp
  802ecf:	48 83 ec 40          	sub    $0x40,%rsp
  802ed3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802ed6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ed9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802edd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802ee0:	48 89 d6             	mov    %rdx,%rsi
  802ee3:	89 c7                	mov    %eax,%edi
  802ee5:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
  802ef1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef8:	79 08                	jns    802f02 <dup+0x37>
		return r;
  802efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efd:	e9 70 01 00 00       	jmpq   803072 <dup+0x1a7>
	close(newfdnum);
  802f02:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f05:	89 c7                	mov    %eax,%edi
  802f07:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802f13:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f16:	48 98                	cltq   
  802f18:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802f1e:	48 c1 e0 0c          	shl    $0xc,%rax
  802f22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802f26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f2a:	48 89 c7             	mov    %rax,%rdi
  802f2d:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax
  802f39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f41:	48 89 c7             	mov    %rax,%rdi
  802f44:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
  802f50:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802f54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f58:	48 c1 e8 15          	shr    $0x15,%rax
  802f5c:	48 89 c2             	mov    %rax,%rdx
  802f5f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802f66:	01 00 00 
  802f69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f6d:	83 e0 01             	and    $0x1,%eax
  802f70:	48 85 c0             	test   %rax,%rax
  802f73:	74 73                	je     802fe8 <dup+0x11d>
  802f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f79:	48 c1 e8 0c          	shr    $0xc,%rax
  802f7d:	48 89 c2             	mov    %rax,%rdx
  802f80:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f87:	01 00 00 
  802f8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f8e:	83 e0 01             	and    $0x1,%eax
  802f91:	48 85 c0             	test   %rax,%rax
  802f94:	74 52                	je     802fe8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9a:	48 c1 e8 0c          	shr    $0xc,%rax
  802f9e:	48 89 c2             	mov    %rax,%rdx
  802fa1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802fa8:	01 00 00 
  802fab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802faf:	25 07 0e 00 00       	and    $0xe07,%eax
  802fb4:	89 c1                	mov    %eax,%ecx
  802fb6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbe:	41 89 c8             	mov    %ecx,%r8d
  802fc1:	48 89 d1             	mov    %rdx,%rcx
  802fc4:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc9:	48 89 c6             	mov    %rax,%rsi
  802fcc:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd1:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
  802fdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe4:	79 02                	jns    802fe8 <dup+0x11d>
			goto err;
  802fe6:	eb 57                	jmp    80303f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fec:	48 c1 e8 0c          	shr    $0xc,%rax
  802ff0:	48 89 c2             	mov    %rax,%rdx
  802ff3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ffa:	01 00 00 
  802ffd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803001:	25 07 0e 00 00       	and    $0xe07,%eax
  803006:	89 c1                	mov    %eax,%ecx
  803008:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80300c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803010:	41 89 c8             	mov    %ecx,%r8d
  803013:	48 89 d1             	mov    %rdx,%rcx
  803016:	ba 00 00 00 00       	mov    $0x0,%edx
  80301b:	48 89 c6             	mov    %rax,%rsi
  80301e:	bf 00 00 00 00       	mov    $0x0,%edi
  803023:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  80302a:	00 00 00 
  80302d:	ff d0                	callq  *%rax
  80302f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803032:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803036:	79 02                	jns    80303a <dup+0x16f>
		goto err;
  803038:	eb 05                	jmp    80303f <dup+0x174>

	return newfdnum;
  80303a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80303d:	eb 33                	jmp    803072 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80303f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803043:	48 89 c6             	mov    %rax,%rsi
  803046:	bf 00 00 00 00       	mov    $0x0,%edi
  80304b:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803052:	00 00 00 
  803055:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803057:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80305b:	48 89 c6             	mov    %rax,%rsi
  80305e:	bf 00 00 00 00       	mov    $0x0,%edi
  803063:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  80306a:	00 00 00 
  80306d:	ff d0                	callq  *%rax
	return r;
  80306f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803072:	c9                   	leaveq 
  803073:	c3                   	retq   

0000000000803074 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803074:	55                   	push   %rbp
  803075:	48 89 e5             	mov    %rsp,%rbp
  803078:	48 83 ec 40          	sub    $0x40,%rsp
  80307c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80307f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803083:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803087:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80308b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80308e:	48 89 d6             	mov    %rdx,%rsi
  803091:	89 c7                	mov    %eax,%edi
  803093:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
  80309f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a6:	78 24                	js     8030cc <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ac:	8b 00                	mov    (%rax),%eax
  8030ae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030b2:	48 89 d6             	mov    %rdx,%rsi
  8030b5:	89 c7                	mov    %eax,%edi
  8030b7:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
  8030c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ca:	79 05                	jns    8030d1 <read+0x5d>
		return r;
  8030cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cf:	eb 76                	jmp    803147 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8030d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d5:	8b 40 08             	mov    0x8(%rax),%eax
  8030d8:	83 e0 03             	and    $0x3,%eax
  8030db:	83 f8 01             	cmp    $0x1,%eax
  8030de:	75 3a                	jne    80311a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8030e0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8030e7:	00 00 00 
  8030ea:	48 8b 00             	mov    (%rax),%rax
  8030ed:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030f3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030f6:	89 c6                	mov    %eax,%esi
  8030f8:	48 bf 57 56 80 00 00 	movabs $0x805657,%rdi
  8030ff:	00 00 00 
  803102:	b8 00 00 00 00       	mov    $0x0,%eax
  803107:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  80310e:	00 00 00 
  803111:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803113:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803118:	eb 2d                	jmp    803147 <read+0xd3>
	}
	if (!dev->dev_read)
  80311a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311e:	48 8b 40 10          	mov    0x10(%rax),%rax
  803122:	48 85 c0             	test   %rax,%rax
  803125:	75 07                	jne    80312e <read+0xba>
		return -E_NOT_SUPP;
  803127:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80312c:	eb 19                	jmp    803147 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80312e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803132:	48 8b 40 10          	mov    0x10(%rax),%rax
  803136:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80313a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80313e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803142:	48 89 cf             	mov    %rcx,%rdi
  803145:	ff d0                	callq  *%rax
}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 83 ec 30          	sub    $0x30,%rsp
  803151:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803154:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803158:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80315c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803163:	eb 49                	jmp    8031ae <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803168:	48 98                	cltq   
  80316a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80316e:	48 29 c2             	sub    %rax,%rdx
  803171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803174:	48 63 c8             	movslq %eax,%rcx
  803177:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317b:	48 01 c1             	add    %rax,%rcx
  80317e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803181:	48 89 ce             	mov    %rcx,%rsi
  803184:	89 c7                	mov    %eax,%edi
  803186:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  80318d:	00 00 00 
  803190:	ff d0                	callq  *%rax
  803192:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803195:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803199:	79 05                	jns    8031a0 <readn+0x57>
			return m;
  80319b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80319e:	eb 1c                	jmp    8031bc <readn+0x73>
		if (m == 0)
  8031a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031a4:	75 02                	jne    8031a8 <readn+0x5f>
			break;
  8031a6:	eb 11                	jmp    8031b9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8031a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ab:	01 45 fc             	add    %eax,-0x4(%rbp)
  8031ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b1:	48 98                	cltq   
  8031b3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8031b7:	72 ac                	jb     803165 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8031b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031bc:	c9                   	leaveq 
  8031bd:	c3                   	retq   

00000000008031be <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8031be:	55                   	push   %rbp
  8031bf:	48 89 e5             	mov    %rsp,%rbp
  8031c2:	48 83 ec 40          	sub    $0x40,%rsp
  8031c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031cd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031d1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031d8:	48 89 d6             	mov    %rdx,%rsi
  8031db:	89 c7                	mov    %eax,%edi
  8031dd:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  8031e4:	00 00 00 
  8031e7:	ff d0                	callq  *%rax
  8031e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f0:	78 24                	js     803216 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f6:	8b 00                	mov    (%rax),%eax
  8031f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031fc:	48 89 d6             	mov    %rdx,%rsi
  8031ff:	89 c7                	mov    %eax,%edi
  803201:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803210:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803214:	79 05                	jns    80321b <write+0x5d>
		return r;
  803216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803219:	eb 75                	jmp    803290 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80321b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321f:	8b 40 08             	mov    0x8(%rax),%eax
  803222:	83 e0 03             	and    $0x3,%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	75 3a                	jne    803263 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803229:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803230:	00 00 00 
  803233:	48 8b 00             	mov    (%rax),%rax
  803236:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80323c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80323f:	89 c6                	mov    %eax,%esi
  803241:	48 bf 73 56 80 00 00 	movabs $0x805673,%rdi
  803248:	00 00 00 
  80324b:	b8 00 00 00 00       	mov    $0x0,%eax
  803250:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  803257:	00 00 00 
  80325a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80325c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803261:	eb 2d                	jmp    803290 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803267:	48 8b 40 18          	mov    0x18(%rax),%rax
  80326b:	48 85 c0             	test   %rax,%rax
  80326e:	75 07                	jne    803277 <write+0xb9>
		return -E_NOT_SUPP;
  803270:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803275:	eb 19                	jmp    803290 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803277:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80327f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803283:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803287:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80328b:	48 89 cf             	mov    %rcx,%rdi
  80328e:	ff d0                	callq  *%rax
}
  803290:	c9                   	leaveq 
  803291:	c3                   	retq   

0000000000803292 <seek>:

int
seek(int fdnum, off_t offset)
{
  803292:	55                   	push   %rbp
  803293:	48 89 e5             	mov    %rsp,%rbp
  803296:	48 83 ec 18          	sub    $0x18,%rsp
  80329a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80329d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a7:	48 89 d6             	mov    %rdx,%rsi
  8032aa:	89 c7                	mov    %eax,%edi
  8032ac:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  8032b3:	00 00 00 
  8032b6:	ff d0                	callq  *%rax
  8032b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032bf:	79 05                	jns    8032c6 <seek+0x34>
		return r;
  8032c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c4:	eb 0f                	jmp    8032d5 <seek+0x43>
	fd->fd_offset = offset;
  8032c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032cd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8032d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032d5:	c9                   	leaveq 
  8032d6:	c3                   	retq   

00000000008032d7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8032d7:	55                   	push   %rbp
  8032d8:	48 89 e5             	mov    %rsp,%rbp
  8032db:	48 83 ec 30          	sub    $0x30,%rsp
  8032df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032e2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032e5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032ec:	48 89 d6             	mov    %rdx,%rsi
  8032ef:	89 c7                	mov    %eax,%edi
  8032f1:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
  8032fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803300:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803304:	78 24                	js     80332a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330a:	8b 00                	mov    (%rax),%eax
  80330c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803310:	48 89 d6             	mov    %rdx,%rsi
  803313:	89 c7                	mov    %eax,%edi
  803315:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	callq  *%rax
  803321:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803324:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803328:	79 05                	jns    80332f <ftruncate+0x58>
		return r;
  80332a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332d:	eb 72                	jmp    8033a1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80332f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803333:	8b 40 08             	mov    0x8(%rax),%eax
  803336:	83 e0 03             	and    $0x3,%eax
  803339:	85 c0                	test   %eax,%eax
  80333b:	75 3a                	jne    803377 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80333d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803344:	00 00 00 
  803347:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80334a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803350:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803353:	89 c6                	mov    %eax,%esi
  803355:	48 bf 90 56 80 00 00 	movabs $0x805690,%rdi
  80335c:	00 00 00 
  80335f:	b8 00 00 00 00       	mov    $0x0,%eax
  803364:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  80336b:	00 00 00 
  80336e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803370:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803375:	eb 2a                	jmp    8033a1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80337f:	48 85 c0             	test   %rax,%rax
  803382:	75 07                	jne    80338b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803384:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803389:	eb 16                	jmp    8033a1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80338b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803393:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803397:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80339a:	89 ce                	mov    %ecx,%esi
  80339c:	48 89 d7             	mov    %rdx,%rdi
  80339f:	ff d0                	callq  *%rax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 30          	sub    $0x30,%rsp
  8033ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8033ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033b9:	48 89 d6             	mov    %rdx,%rsi
  8033bc:	89 c7                	mov    %eax,%edi
  8033be:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
  8033ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d1:	78 24                	js     8033f7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d7:	8b 00                	mov    (%rax),%eax
  8033d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033dd:	48 89 d6             	mov    %rdx,%rsi
  8033e0:	89 c7                	mov    %eax,%edi
  8033e2:	48 b8 9b 2d 80 00 00 	movabs $0x802d9b,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
  8033ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f5:	79 05                	jns    8033fc <fstat+0x59>
		return r;
  8033f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fa:	eb 5e                	jmp    80345a <fstat+0xb7>
	if (!dev->dev_stat)
  8033fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803400:	48 8b 40 28          	mov    0x28(%rax),%rax
  803404:	48 85 c0             	test   %rax,%rax
  803407:	75 07                	jne    803410 <fstat+0x6d>
		return -E_NOT_SUPP;
  803409:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80340e:	eb 4a                	jmp    80345a <fstat+0xb7>
	stat->st_name[0] = 0;
  803410:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803414:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803417:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80341b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803422:	00 00 00 
	stat->st_isdir = 0;
  803425:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803429:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803430:	00 00 00 
	stat->st_dev = dev;
  803433:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803437:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803446:	48 8b 40 28          	mov    0x28(%rax),%rax
  80344a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80344e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803452:	48 89 ce             	mov    %rcx,%rsi
  803455:	48 89 d7             	mov    %rdx,%rdi
  803458:	ff d0                	callq  *%rax
}
  80345a:	c9                   	leaveq 
  80345b:	c3                   	retq   

000000000080345c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80345c:	55                   	push   %rbp
  80345d:	48 89 e5             	mov    %rsp,%rbp
  803460:	48 83 ec 20          	sub    $0x20,%rsp
  803464:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803468:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80346c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803470:	be 00 00 00 00       	mov    $0x0,%esi
  803475:	48 89 c7             	mov    %rax,%rdi
  803478:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
  803484:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803487:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348b:	79 05                	jns    803492 <stat+0x36>
		return fd;
  80348d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803490:	eb 2f                	jmp    8034c1 <stat+0x65>
	r = fstat(fd, stat);
  803492:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803499:	48 89 d6             	mov    %rdx,%rsi
  80349c:	89 c7                	mov    %eax,%edi
  80349e:	48 b8 a3 33 80 00 00 	movabs $0x8033a3,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
  8034aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8034ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b0:	89 c7                	mov    %eax,%edi
  8034b2:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
	return r;
  8034be:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8034c1:	c9                   	leaveq 
  8034c2:	c3                   	retq   

00000000008034c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8034c3:	55                   	push   %rbp
  8034c4:	48 89 e5             	mov    %rsp,%rbp
  8034c7:	48 83 ec 10          	sub    $0x10,%rsp
  8034cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8034d2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034d9:	00 00 00 
  8034dc:	8b 00                	mov    (%rax),%eax
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	75 1d                	jne    8034ff <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8034e2:	bf 01 00 00 00       	mov    $0x1,%edi
  8034e7:	48 b8 ea 2a 80 00 00 	movabs $0x802aea,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
  8034f3:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8034fa:	00 00 00 
  8034fd:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8034ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803506:	00 00 00 
  803509:	8b 00                	mov    (%rax),%eax
  80350b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80350e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803513:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80351a:	00 00 00 
  80351d:	89 c7                	mov    %eax,%edi
  80351f:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  803526:	00 00 00 
  803529:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80352b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352f:	ba 00 00 00 00       	mov    $0x0,%edx
  803534:	48 89 c6             	mov    %rax,%rsi
  803537:	bf 00 00 00 00       	mov    $0x0,%edi
  80353c:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
}
  803548:	c9                   	leaveq 
  803549:	c3                   	retq   

000000000080354a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80354a:	55                   	push   %rbp
  80354b:	48 89 e5             	mov    %rsp,%rbp
  80354e:	48 83 ec 20          	sub    $0x20,%rsp
  803552:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803556:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355d:	48 89 c7             	mov    %rax,%rdi
  803560:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  803567:	00 00 00 
  80356a:	ff d0                	callq  *%rax
  80356c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803571:	7e 0a                	jle    80357d <open+0x33>
		return -E_BAD_PATH;
  803573:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803578:	e9 a5 00 00 00       	jmpq   803622 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80357d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803581:	48 89 c7             	mov    %rax,%rdi
  803584:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
  803590:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803593:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803597:	79 08                	jns    8035a1 <open+0x57>
		return r;
  803599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359c:	e9 81 00 00 00       	jmpq   803622 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8035a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a5:	48 89 c6             	mov    %rax,%rsi
  8035a8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8035af:	00 00 00 
  8035b2:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8035b9:	00 00 00 
  8035bc:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8035be:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035c5:	00 00 00 
  8035c8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035cb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8035d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d5:	48 89 c6             	mov    %rax,%rsi
  8035d8:	bf 01 00 00 00       	mov    $0x1,%edi
  8035dd:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
  8035e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f0:	79 1d                	jns    80360f <open+0xc5>
		fd_close(fd, 0);
  8035f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f6:	be 00 00 00 00       	mov    $0x0,%esi
  8035fb:	48 89 c7             	mov    %rax,%rdi
  8035fe:	48 b8 d2 2c 80 00 00 	movabs $0x802cd2,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax
		return r;
  80360a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360d:	eb 13                	jmp    803622 <open+0xd8>
	}

	return fd2num(fd);
  80360f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803613:	48 89 c7             	mov    %rax,%rdi
  803616:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax

}
  803622:	c9                   	leaveq 
  803623:	c3                   	retq   

0000000000803624 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803624:	55                   	push   %rbp
  803625:	48 89 e5             	mov    %rsp,%rbp
  803628:	48 83 ec 10          	sub    $0x10,%rsp
  80362c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803634:	8b 50 0c             	mov    0xc(%rax),%edx
  803637:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80363e:	00 00 00 
  803641:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803643:	be 00 00 00 00       	mov    $0x0,%esi
  803648:	bf 06 00 00 00       	mov    $0x6,%edi
  80364d:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  803654:	00 00 00 
  803657:	ff d0                	callq  *%rax
}
  803659:	c9                   	leaveq 
  80365a:	c3                   	retq   

000000000080365b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80365b:	55                   	push   %rbp
  80365c:	48 89 e5             	mov    %rsp,%rbp
  80365f:	48 83 ec 30          	sub    $0x30,%rsp
  803663:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803667:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80366b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80366f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803673:	8b 50 0c             	mov    0xc(%rax),%edx
  803676:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80367d:	00 00 00 
  803680:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803682:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803689:	00 00 00 
  80368c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803690:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803694:	be 00 00 00 00       	mov    $0x0,%esi
  803699:	bf 03 00 00 00       	mov    $0x3,%edi
  80369e:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
  8036aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b1:	79 08                	jns    8036bb <devfile_read+0x60>
		return r;
  8036b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b6:	e9 a4 00 00 00       	jmpq   80375f <devfile_read+0x104>
	assert(r <= n);
  8036bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036be:	48 98                	cltq   
  8036c0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8036c4:	76 35                	jbe    8036fb <devfile_read+0xa0>
  8036c6:	48 b9 b6 56 80 00 00 	movabs $0x8056b6,%rcx
  8036cd:	00 00 00 
  8036d0:	48 ba bd 56 80 00 00 	movabs $0x8056bd,%rdx
  8036d7:	00 00 00 
  8036da:	be 86 00 00 00       	mov    $0x86,%esi
  8036df:	48 bf d2 56 80 00 00 	movabs $0x8056d2,%rdi
  8036e6:	00 00 00 
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ee:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8036f5:	00 00 00 
  8036f8:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8036fb:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803702:	7e 35                	jle    803739 <devfile_read+0xde>
  803704:	48 b9 dd 56 80 00 00 	movabs $0x8056dd,%rcx
  80370b:	00 00 00 
  80370e:	48 ba bd 56 80 00 00 	movabs $0x8056bd,%rdx
  803715:	00 00 00 
  803718:	be 87 00 00 00       	mov    $0x87,%esi
  80371d:	48 bf d2 56 80 00 00 	movabs $0x8056d2,%rdi
  803724:	00 00 00 
  803727:	b8 00 00 00 00       	mov    $0x0,%eax
  80372c:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  803733:	00 00 00 
  803736:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373c:	48 63 d0             	movslq %eax,%rdx
  80373f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803743:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80374a:	00 00 00 
  80374d:	48 89 c7             	mov    %rax,%rdi
  803750:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
	return r;
  80375c:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80375f:	c9                   	leaveq 
  803760:	c3                   	retq   

0000000000803761 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803761:	55                   	push   %rbp
  803762:	48 89 e5             	mov    %rsp,%rbp
  803765:	48 83 ec 40          	sub    $0x40,%rsp
  803769:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80376d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803771:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803775:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803779:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80377d:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803784:	00 
  803785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803789:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80378d:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803792:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80379a:	8b 50 0c             	mov    0xc(%rax),%edx
  80379d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037a4:	00 00 00 
  8037a7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8037a9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037b0:	00 00 00 
  8037b3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8037b7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8037bb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8037bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c3:	48 89 c6             	mov    %rax,%rsi
  8037c6:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8037cd:	00 00 00 
  8037d0:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8037dc:	be 00 00 00 00       	mov    $0x0,%esi
  8037e1:	bf 04 00 00 00       	mov    $0x4,%edi
  8037e6:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  8037ed:	00 00 00 
  8037f0:	ff d0                	callq  *%rax
  8037f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037f9:	79 05                	jns    803800 <devfile_write+0x9f>
		return r;
  8037fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fe:	eb 43                	jmp    803843 <devfile_write+0xe2>
	assert(r <= n);
  803800:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803803:	48 98                	cltq   
  803805:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803809:	76 35                	jbe    803840 <devfile_write+0xdf>
  80380b:	48 b9 b6 56 80 00 00 	movabs $0x8056b6,%rcx
  803812:	00 00 00 
  803815:	48 ba bd 56 80 00 00 	movabs $0x8056bd,%rdx
  80381c:	00 00 00 
  80381f:	be a2 00 00 00       	mov    $0xa2,%esi
  803824:	48 bf d2 56 80 00 00 	movabs $0x8056d2,%rdi
  80382b:	00 00 00 
  80382e:	b8 00 00 00 00       	mov    $0x0,%eax
  803833:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80383a:	00 00 00 
  80383d:	41 ff d0             	callq  *%r8
	return r;
  803840:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803843:	c9                   	leaveq 
  803844:	c3                   	retq   

0000000000803845 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803845:	55                   	push   %rbp
  803846:	48 89 e5             	mov    %rsp,%rbp
  803849:	48 83 ec 20          	sub    $0x20,%rsp
  80384d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803851:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803859:	8b 50 0c             	mov    0xc(%rax),%edx
  80385c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803863:	00 00 00 
  803866:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803868:	be 00 00 00 00       	mov    $0x0,%esi
  80386d:	bf 05 00 00 00       	mov    $0x5,%edi
  803872:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  803879:	00 00 00 
  80387c:	ff d0                	callq  *%rax
  80387e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803885:	79 05                	jns    80388c <devfile_stat+0x47>
		return r;
  803887:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388a:	eb 56                	jmp    8038e2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80388c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803890:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803897:	00 00 00 
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8038a9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038b0:	00 00 00 
  8038b3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8038b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038bd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8038c3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038ca:	00 00 00 
  8038cd:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8038d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d7:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8038dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038e2:	c9                   	leaveq 
  8038e3:	c3                   	retq   

00000000008038e4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8038e4:	55                   	push   %rbp
  8038e5:	48 89 e5             	mov    %rsp,%rbp
  8038e8:	48 83 ec 10          	sub    $0x10,%rsp
  8038ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038f0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8038f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f7:	8b 50 0c             	mov    0xc(%rax),%edx
  8038fa:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803901:	00 00 00 
  803904:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803906:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80390d:	00 00 00 
  803910:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803913:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803916:	be 00 00 00 00       	mov    $0x0,%esi
  80391b:	bf 02 00 00 00       	mov    $0x2,%edi
  803920:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  803927:	00 00 00 
  80392a:	ff d0                	callq  *%rax
}
  80392c:	c9                   	leaveq 
  80392d:	c3                   	retq   

000000000080392e <remove>:

// Delete a file
int
remove(const char *path)
{
  80392e:	55                   	push   %rbp
  80392f:	48 89 e5             	mov    %rsp,%rbp
  803932:	48 83 ec 10          	sub    $0x10,%rsp
  803936:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80393a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80393e:	48 89 c7             	mov    %rax,%rdi
  803941:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
  80394d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803952:	7e 07                	jle    80395b <remove+0x2d>
		return -E_BAD_PATH;
  803954:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803959:	eb 33                	jmp    80398e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80395b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395f:	48 89 c6             	mov    %rax,%rsi
  803962:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803969:	00 00 00 
  80396c:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803973:	00 00 00 
  803976:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803978:	be 00 00 00 00       	mov    $0x0,%esi
  80397d:	bf 07 00 00 00       	mov    $0x7,%edi
  803982:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  803989:	00 00 00 
  80398c:	ff d0                	callq  *%rax
}
  80398e:	c9                   	leaveq 
  80398f:	c3                   	retq   

0000000000803990 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803990:	55                   	push   %rbp
  803991:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803994:	be 00 00 00 00       	mov    $0x0,%esi
  803999:	bf 08 00 00 00       	mov    $0x8,%edi
  80399e:	48 b8 c3 34 80 00 00 	movabs $0x8034c3,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
}
  8039aa:	5d                   	pop    %rbp
  8039ab:	c3                   	retq   

00000000008039ac <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8039ac:	55                   	push   %rbp
  8039ad:	48 89 e5             	mov    %rsp,%rbp
  8039b0:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8039b7:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8039be:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8039c5:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8039cc:	be 00 00 00 00       	mov    $0x0,%esi
  8039d1:	48 89 c7             	mov    %rax,%rdi
  8039d4:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
  8039e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8039e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e7:	79 28                	jns    803a11 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8039e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ec:	89 c6                	mov    %eax,%esi
  8039ee:	48 bf e9 56 80 00 00 	movabs $0x8056e9,%rdi
  8039f5:	00 00 00 
  8039f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fd:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803a04:	00 00 00 
  803a07:	ff d2                	callq  *%rdx
		return fd_src;
  803a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0c:	e9 74 01 00 00       	jmpq   803b85 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803a11:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803a18:	be 01 01 00 00       	mov    $0x101,%esi
  803a1d:	48 89 c7             	mov    %rax,%rdi
  803a20:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  803a27:	00 00 00 
  803a2a:	ff d0                	callq  *%rax
  803a2c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803a2f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a33:	79 39                	jns    803a6e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803a35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a38:	89 c6                	mov    %eax,%esi
  803a3a:	48 bf ff 56 80 00 00 	movabs $0x8056ff,%rdi
  803a41:	00 00 00 
  803a44:	b8 00 00 00 00       	mov    $0x0,%eax
  803a49:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803a50:	00 00 00 
  803a53:	ff d2                	callq  *%rdx
		close(fd_src);
  803a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a58:	89 c7                	mov    %eax,%edi
  803a5a:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
		return fd_dest;
  803a66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a69:	e9 17 01 00 00       	jmpq   803b85 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803a6e:	eb 74                	jmp    803ae4 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803a70:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a73:	48 63 d0             	movslq %eax,%rdx
  803a76:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a80:	48 89 ce             	mov    %rcx,%rsi
  803a83:	89 c7                	mov    %eax,%edi
  803a85:	48 b8 be 31 80 00 00 	movabs $0x8031be,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
  803a91:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803a98:	79 4a                	jns    803ae4 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803a9a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a9d:	89 c6                	mov    %eax,%esi
  803a9f:	48 bf 19 57 80 00 00 	movabs $0x805719,%rdi
  803aa6:	00 00 00 
  803aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  803aae:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803ab5:	00 00 00 
  803ab8:	ff d2                	callq  *%rdx
			close(fd_src);
  803aba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abd:	89 c7                	mov    %eax,%edi
  803abf:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
			close(fd_dest);
  803acb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ace:	89 c7                	mov    %eax,%edi
  803ad0:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  803ad7:	00 00 00 
  803ada:	ff d0                	callq  *%rax
			return write_size;
  803adc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803adf:	e9 a1 00 00 00       	jmpq   803b85 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803ae4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aee:	ba 00 02 00 00       	mov    $0x200,%edx
  803af3:	48 89 ce             	mov    %rcx,%rsi
  803af6:	89 c7                	mov    %eax,%edi
  803af8:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  803aff:	00 00 00 
  803b02:	ff d0                	callq  *%rax
  803b04:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803b0b:	0f 8f 5f ff ff ff    	jg     803a70 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803b11:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803b15:	79 47                	jns    803b5e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803b17:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b1a:	89 c6                	mov    %eax,%esi
  803b1c:	48 bf 2c 57 80 00 00 	movabs $0x80572c,%rdi
  803b23:	00 00 00 
  803b26:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2b:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803b32:	00 00 00 
  803b35:	ff d2                	callq  *%rdx
		close(fd_src);
  803b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3a:	89 c7                	mov    %eax,%edi
  803b3c:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  803b43:	00 00 00 
  803b46:	ff d0                	callq  *%rax
		close(fd_dest);
  803b48:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b4b:	89 c7                	mov    %eax,%edi
  803b4d:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  803b54:	00 00 00 
  803b57:	ff d0                	callq  *%rax
		return read_size;
  803b59:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b5c:	eb 27                	jmp    803b85 <copy+0x1d9>
	}
	close(fd_src);
  803b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b61:	89 c7                	mov    %eax,%edi
  803b63:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  803b6a:	00 00 00 
  803b6d:	ff d0                	callq  *%rax
	close(fd_dest);
  803b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b72:	89 c7                	mov    %eax,%edi
  803b74:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  803b7b:	00 00 00 
  803b7e:	ff d0                	callq  *%rax
	return 0;
  803b80:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803b85:	c9                   	leaveq 
  803b86:	c3                   	retq   

0000000000803b87 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803b87:	55                   	push   %rbp
  803b88:	48 89 e5             	mov    %rsp,%rbp
  803b8b:	48 83 ec 20          	sub    $0x20,%rsp
  803b8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803b92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b99:	48 89 d6             	mov    %rdx,%rsi
  803b9c:	89 c7                	mov    %eax,%edi
  803b9e:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  803ba5:	00 00 00 
  803ba8:	ff d0                	callq  *%rax
  803baa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb1:	79 05                	jns    803bb8 <fd2sockid+0x31>
		return r;
  803bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb6:	eb 24                	jmp    803bdc <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbc:	8b 10                	mov    (%rax),%edx
  803bbe:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803bc5:	00 00 00 
  803bc8:	8b 00                	mov    (%rax),%eax
  803bca:	39 c2                	cmp    %eax,%edx
  803bcc:	74 07                	je     803bd5 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803bce:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803bd3:	eb 07                	jmp    803bdc <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd9:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803bdc:	c9                   	leaveq 
  803bdd:	c3                   	retq   

0000000000803bde <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803bde:	55                   	push   %rbp
  803bdf:	48 89 e5             	mov    %rsp,%rbp
  803be2:	48 83 ec 20          	sub    $0x20,%rsp
  803be6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803be9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bed:	48 89 c7             	mov    %rax,%rdi
  803bf0:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  803bf7:	00 00 00 
  803bfa:	ff d0                	callq  *%rax
  803bfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c03:	78 26                	js     803c2b <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803c05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c09:	ba 07 04 00 00       	mov    $0x407,%edx
  803c0e:	48 89 c6             	mov    %rax,%rsi
  803c11:	bf 00 00 00 00       	mov    $0x0,%edi
  803c16:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  803c1d:	00 00 00 
  803c20:	ff d0                	callq  *%rax
  803c22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c29:	79 16                	jns    803c41 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803c2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c2e:	89 c7                	mov    %eax,%edi
  803c30:	48 b8 eb 40 80 00 00 	movabs $0x8040eb,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
		return r;
  803c3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3f:	eb 3a                	jmp    803c7b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803c41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c45:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803c4c:	00 00 00 
  803c4f:	8b 12                	mov    (%rdx),%edx
  803c51:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c57:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c62:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c65:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c6c:	48 89 c7             	mov    %rax,%rdi
  803c6f:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
}
  803c7b:	c9                   	leaveq 
  803c7c:	c3                   	retq   

0000000000803c7d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c7d:	55                   	push   %rbp
  803c7e:	48 89 e5             	mov    %rsp,%rbp
  803c81:	48 83 ec 30          	sub    $0x30,%rsp
  803c85:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c88:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c8c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c93:	89 c7                	mov    %eax,%edi
  803c95:	48 b8 87 3b 80 00 00 	movabs $0x803b87,%rax
  803c9c:	00 00 00 
  803c9f:	ff d0                	callq  *%rax
  803ca1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca8:	79 05                	jns    803caf <accept+0x32>
		return r;
  803caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cad:	eb 3b                	jmp    803cea <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803caf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803cb3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cba:	48 89 ce             	mov    %rcx,%rsi
  803cbd:	89 c7                	mov    %eax,%edi
  803cbf:	48 b8 c8 3f 80 00 00 	movabs $0x803fc8,%rax
  803cc6:	00 00 00 
  803cc9:	ff d0                	callq  *%rax
  803ccb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd2:	79 05                	jns    803cd9 <accept+0x5c>
		return r;
  803cd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd7:	eb 11                	jmp    803cea <accept+0x6d>
	return alloc_sockfd(r);
  803cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdc:	89 c7                	mov    %eax,%edi
  803cde:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
}
  803cea:	c9                   	leaveq 
  803ceb:	c3                   	retq   

0000000000803cec <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803cec:	55                   	push   %rbp
  803ced:	48 89 e5             	mov    %rsp,%rbp
  803cf0:	48 83 ec 20          	sub    $0x20,%rsp
  803cf4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cf7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cfb:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cfe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d01:	89 c7                	mov    %eax,%edi
  803d03:	48 b8 87 3b 80 00 00 	movabs $0x803b87,%rax
  803d0a:	00 00 00 
  803d0d:	ff d0                	callq  *%rax
  803d0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d16:	79 05                	jns    803d1d <bind+0x31>
		return r;
  803d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1b:	eb 1b                	jmp    803d38 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803d1d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d20:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d27:	48 89 ce             	mov    %rcx,%rsi
  803d2a:	89 c7                	mov    %eax,%edi
  803d2c:	48 b8 47 40 80 00 00 	movabs $0x804047,%rax
  803d33:	00 00 00 
  803d36:	ff d0                	callq  *%rax
}
  803d38:	c9                   	leaveq 
  803d39:	c3                   	retq   

0000000000803d3a <shutdown>:

int
shutdown(int s, int how)
{
  803d3a:	55                   	push   %rbp
  803d3b:	48 89 e5             	mov    %rsp,%rbp
  803d3e:	48 83 ec 20          	sub    $0x20,%rsp
  803d42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d45:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d4b:	89 c7                	mov    %eax,%edi
  803d4d:	48 b8 87 3b 80 00 00 	movabs $0x803b87,%rax
  803d54:	00 00 00 
  803d57:	ff d0                	callq  *%rax
  803d59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d60:	79 05                	jns    803d67 <shutdown+0x2d>
		return r;
  803d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d65:	eb 16                	jmp    803d7d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803d67:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6d:	89 d6                	mov    %edx,%esi
  803d6f:	89 c7                	mov    %eax,%edi
  803d71:	48 b8 ab 40 80 00 00 	movabs $0x8040ab,%rax
  803d78:	00 00 00 
  803d7b:	ff d0                	callq  *%rax
}
  803d7d:	c9                   	leaveq 
  803d7e:	c3                   	retq   

0000000000803d7f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803d7f:	55                   	push   %rbp
  803d80:	48 89 e5             	mov    %rsp,%rbp
  803d83:	48 83 ec 10          	sub    $0x10,%rsp
  803d87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d8f:	48 89 c7             	mov    %rax,%rdi
  803d92:	48 b8 0f 4c 80 00 00 	movabs $0x804c0f,%rax
  803d99:	00 00 00 
  803d9c:	ff d0                	callq  *%rax
  803d9e:	83 f8 01             	cmp    $0x1,%eax
  803da1:	75 17                	jne    803dba <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da7:	8b 40 0c             	mov    0xc(%rax),%eax
  803daa:	89 c7                	mov    %eax,%edi
  803dac:	48 b8 eb 40 80 00 00 	movabs $0x8040eb,%rax
  803db3:	00 00 00 
  803db6:	ff d0                	callq  *%rax
  803db8:	eb 05                	jmp    803dbf <devsock_close+0x40>
	else
		return 0;
  803dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dbf:	c9                   	leaveq 
  803dc0:	c3                   	retq   

0000000000803dc1 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803dc1:	55                   	push   %rbp
  803dc2:	48 89 e5             	mov    %rsp,%rbp
  803dc5:	48 83 ec 20          	sub    $0x20,%rsp
  803dc9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803dcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dd0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803dd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd6:	89 c7                	mov    %eax,%edi
  803dd8:	48 b8 87 3b 80 00 00 	movabs $0x803b87,%rax
  803ddf:	00 00 00 
  803de2:	ff d0                	callq  *%rax
  803de4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803deb:	79 05                	jns    803df2 <connect+0x31>
		return r;
  803ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df0:	eb 1b                	jmp    803e0d <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803df2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803df5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803df9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfc:	48 89 ce             	mov    %rcx,%rsi
  803dff:	89 c7                	mov    %eax,%edi
  803e01:	48 b8 18 41 80 00 00 	movabs $0x804118,%rax
  803e08:	00 00 00 
  803e0b:	ff d0                	callq  *%rax
}
  803e0d:	c9                   	leaveq 
  803e0e:	c3                   	retq   

0000000000803e0f <listen>:

int
listen(int s, int backlog)
{
  803e0f:	55                   	push   %rbp
  803e10:	48 89 e5             	mov    %rsp,%rbp
  803e13:	48 83 ec 20          	sub    $0x20,%rsp
  803e17:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e1a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e20:	89 c7                	mov    %eax,%edi
  803e22:	48 b8 87 3b 80 00 00 	movabs $0x803b87,%rax
  803e29:	00 00 00 
  803e2c:	ff d0                	callq  *%rax
  803e2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e35:	79 05                	jns    803e3c <listen+0x2d>
		return r;
  803e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3a:	eb 16                	jmp    803e52 <listen+0x43>
	return nsipc_listen(r, backlog);
  803e3c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e42:	89 d6                	mov    %edx,%esi
  803e44:	89 c7                	mov    %eax,%edi
  803e46:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  803e4d:	00 00 00 
  803e50:	ff d0                	callq  *%rax
}
  803e52:	c9                   	leaveq 
  803e53:	c3                   	retq   

0000000000803e54 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803e54:	55                   	push   %rbp
  803e55:	48 89 e5             	mov    %rsp,%rbp
  803e58:	48 83 ec 20          	sub    $0x20,%rsp
  803e5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e64:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e6c:	89 c2                	mov    %eax,%edx
  803e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e72:	8b 40 0c             	mov    0xc(%rax),%eax
  803e75:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803e79:	b9 00 00 00 00       	mov    $0x0,%ecx
  803e7e:	89 c7                	mov    %eax,%edi
  803e80:	48 b8 bc 41 80 00 00 	movabs $0x8041bc,%rax
  803e87:	00 00 00 
  803e8a:	ff d0                	callq  *%rax
}
  803e8c:	c9                   	leaveq 
  803e8d:	c3                   	retq   

0000000000803e8e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803e8e:	55                   	push   %rbp
  803e8f:	48 89 e5             	mov    %rsp,%rbp
  803e92:	48 83 ec 20          	sub    $0x20,%rsp
  803e96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e9e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ea6:	89 c2                	mov    %eax,%edx
  803ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eac:	8b 40 0c             	mov    0xc(%rax),%eax
  803eaf:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803eb3:	b9 00 00 00 00       	mov    $0x0,%ecx
  803eb8:	89 c7                	mov    %eax,%edi
  803eba:	48 b8 88 42 80 00 00 	movabs $0x804288,%rax
  803ec1:	00 00 00 
  803ec4:	ff d0                	callq  *%rax
}
  803ec6:	c9                   	leaveq 
  803ec7:	c3                   	retq   

0000000000803ec8 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ec8:	55                   	push   %rbp
  803ec9:	48 89 e5             	mov    %rsp,%rbp
  803ecc:	48 83 ec 10          	sub    $0x10,%rsp
  803ed0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ed4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803edc:	48 be 47 57 80 00 00 	movabs $0x805747,%rsi
  803ee3:	00 00 00 
  803ee6:	48 89 c7             	mov    %rax,%rdi
  803ee9:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803ef0:	00 00 00 
  803ef3:	ff d0                	callq  *%rax
	return 0;
  803ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803efa:	c9                   	leaveq 
  803efb:	c3                   	retq   

0000000000803efc <socket>:

int
socket(int domain, int type, int protocol)
{
  803efc:	55                   	push   %rbp
  803efd:	48 89 e5             	mov    %rsp,%rbp
  803f00:	48 83 ec 20          	sub    $0x20,%rsp
  803f04:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f07:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f0a:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803f0d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803f10:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f16:	89 ce                	mov    %ecx,%esi
  803f18:	89 c7                	mov    %eax,%edi
  803f1a:	48 b8 40 43 80 00 00 	movabs $0x804340,%rax
  803f21:	00 00 00 
  803f24:	ff d0                	callq  *%rax
  803f26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f2d:	79 05                	jns    803f34 <socket+0x38>
		return r;
  803f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f32:	eb 11                	jmp    803f45 <socket+0x49>
	return alloc_sockfd(r);
  803f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f37:	89 c7                	mov    %eax,%edi
  803f39:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803f40:	00 00 00 
  803f43:	ff d0                	callq  *%rax
}
  803f45:	c9                   	leaveq 
  803f46:	c3                   	retq   

0000000000803f47 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803f47:	55                   	push   %rbp
  803f48:	48 89 e5             	mov    %rsp,%rbp
  803f4b:	48 83 ec 10          	sub    $0x10,%rsp
  803f4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803f52:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803f59:	00 00 00 
  803f5c:	8b 00                	mov    (%rax),%eax
  803f5e:	85 c0                	test   %eax,%eax
  803f60:	75 1d                	jne    803f7f <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803f62:	bf 02 00 00 00       	mov    $0x2,%edi
  803f67:	48 b8 ea 2a 80 00 00 	movabs $0x802aea,%rax
  803f6e:	00 00 00 
  803f71:	ff d0                	callq  *%rax
  803f73:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803f7a:	00 00 00 
  803f7d:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803f7f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803f86:	00 00 00 
  803f89:	8b 00                	mov    (%rax),%eax
  803f8b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803f8e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803f93:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803f9a:	00 00 00 
  803f9d:	89 c7                	mov    %eax,%edi
  803f9f:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  803fa6:	00 00 00 
  803fa9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803fab:	ba 00 00 00 00       	mov    $0x0,%edx
  803fb0:	be 00 00 00 00       	mov    $0x0,%esi
  803fb5:	bf 00 00 00 00       	mov    $0x0,%edi
  803fba:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  803fc1:	00 00 00 
  803fc4:	ff d0                	callq  *%rax
}
  803fc6:	c9                   	leaveq 
  803fc7:	c3                   	retq   

0000000000803fc8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803fc8:	55                   	push   %rbp
  803fc9:	48 89 e5             	mov    %rsp,%rbp
  803fcc:	48 83 ec 30          	sub    $0x30,%rsp
  803fd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803fdb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fe2:	00 00 00 
  803fe5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fe8:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803fea:	bf 01 00 00 00       	mov    $0x1,%edi
  803fef:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
  803ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804002:	78 3e                	js     804042 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804004:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80400b:	00 00 00 
  80400e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804016:	8b 40 10             	mov    0x10(%rax),%eax
  804019:	89 c2                	mov    %eax,%edx
  80401b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80401f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804023:	48 89 ce             	mov    %rcx,%rsi
  804026:	48 89 c7             	mov    %rax,%rdi
  804029:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804030:	00 00 00 
  804033:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  804035:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804039:	8b 50 10             	mov    0x10(%rax),%edx
  80403c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804040:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804042:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804045:	c9                   	leaveq 
  804046:	c3                   	retq   

0000000000804047 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804047:	55                   	push   %rbp
  804048:	48 89 e5             	mov    %rsp,%rbp
  80404b:	48 83 ec 10          	sub    $0x10,%rsp
  80404f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804052:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804056:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804059:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804060:	00 00 00 
  804063:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804066:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804068:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80406b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406f:	48 89 c6             	mov    %rax,%rsi
  804072:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804079:	00 00 00 
  80407c:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804083:	00 00 00 
  804086:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804088:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80408f:	00 00 00 
  804092:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804095:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804098:	bf 02 00 00 00       	mov    $0x2,%edi
  80409d:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  8040a4:	00 00 00 
  8040a7:	ff d0                	callq  *%rax
}
  8040a9:	c9                   	leaveq 
  8040aa:	c3                   	retq   

00000000008040ab <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8040ab:	55                   	push   %rbp
  8040ac:	48 89 e5             	mov    %rsp,%rbp
  8040af:	48 83 ec 10          	sub    $0x10,%rsp
  8040b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040b6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8040b9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040c0:	00 00 00 
  8040c3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040c6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8040c8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040cf:	00 00 00 
  8040d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040d5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8040d8:	bf 03 00 00 00       	mov    $0x3,%edi
  8040dd:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  8040e4:	00 00 00 
  8040e7:	ff d0                	callq  *%rax
}
  8040e9:	c9                   	leaveq 
  8040ea:	c3                   	retq   

00000000008040eb <nsipc_close>:

int
nsipc_close(int s)
{
  8040eb:	55                   	push   %rbp
  8040ec:	48 89 e5             	mov    %rsp,%rbp
  8040ef:	48 83 ec 10          	sub    $0x10,%rsp
  8040f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8040f6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040fd:	00 00 00 
  804100:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804103:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804105:	bf 04 00 00 00       	mov    $0x4,%edi
  80410a:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
}
  804116:	c9                   	leaveq 
  804117:	c3                   	retq   

0000000000804118 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804118:	55                   	push   %rbp
  804119:	48 89 e5             	mov    %rsp,%rbp
  80411c:	48 83 ec 10          	sub    $0x10,%rsp
  804120:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804123:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804127:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80412a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804131:	00 00 00 
  804134:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804137:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804139:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80413c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804140:	48 89 c6             	mov    %rax,%rsi
  804143:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80414a:	00 00 00 
  80414d:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804154:	00 00 00 
  804157:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804159:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804160:	00 00 00 
  804163:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804166:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804169:	bf 05 00 00 00       	mov    $0x5,%edi
  80416e:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  804175:	00 00 00 
  804178:	ff d0                	callq  *%rax
}
  80417a:	c9                   	leaveq 
  80417b:	c3                   	retq   

000000000080417c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80417c:	55                   	push   %rbp
  80417d:	48 89 e5             	mov    %rsp,%rbp
  804180:	48 83 ec 10          	sub    $0x10,%rsp
  804184:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804187:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80418a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804191:	00 00 00 
  804194:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804197:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804199:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041a0:	00 00 00 
  8041a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8041a6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8041a9:	bf 06 00 00 00       	mov    $0x6,%edi
  8041ae:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  8041b5:	00 00 00 
  8041b8:	ff d0                	callq  *%rax
}
  8041ba:	c9                   	leaveq 
  8041bb:	c3                   	retq   

00000000008041bc <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8041bc:	55                   	push   %rbp
  8041bd:	48 89 e5             	mov    %rsp,%rbp
  8041c0:	48 83 ec 30          	sub    $0x30,%rsp
  8041c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041cb:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8041ce:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8041d1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041d8:	00 00 00 
  8041db:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8041de:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8041e0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041e7:	00 00 00 
  8041ea:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041ed:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8041f0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041f7:	00 00 00 
  8041fa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8041fd:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804200:	bf 07 00 00 00       	mov    $0x7,%edi
  804205:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  80420c:	00 00 00 
  80420f:	ff d0                	callq  *%rax
  804211:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804214:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804218:	78 69                	js     804283 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80421a:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804221:	7f 08                	jg     80422b <nsipc_recv+0x6f>
  804223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804226:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804229:	7e 35                	jle    804260 <nsipc_recv+0xa4>
  80422b:	48 b9 4e 57 80 00 00 	movabs $0x80574e,%rcx
  804232:	00 00 00 
  804235:	48 ba 63 57 80 00 00 	movabs $0x805763,%rdx
  80423c:	00 00 00 
  80423f:	be 62 00 00 00       	mov    $0x62,%esi
  804244:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  80424b:	00 00 00 
  80424e:	b8 00 00 00 00       	mov    $0x0,%eax
  804253:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80425a:	00 00 00 
  80425d:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804263:	48 63 d0             	movslq %eax,%rdx
  804266:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80426a:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804271:	00 00 00 
  804274:	48 89 c7             	mov    %rax,%rdi
  804277:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80427e:	00 00 00 
  804281:	ff d0                	callq  *%rax
	}

	return r;
  804283:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804286:	c9                   	leaveq 
  804287:	c3                   	retq   

0000000000804288 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804288:	55                   	push   %rbp
  804289:	48 89 e5             	mov    %rsp,%rbp
  80428c:	48 83 ec 20          	sub    $0x20,%rsp
  804290:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804293:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804297:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80429a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80429d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042a4:	00 00 00 
  8042a7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042aa:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8042ac:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8042b3:	7e 35                	jle    8042ea <nsipc_send+0x62>
  8042b5:	48 b9 84 57 80 00 00 	movabs $0x805784,%rcx
  8042bc:	00 00 00 
  8042bf:	48 ba 63 57 80 00 00 	movabs $0x805763,%rdx
  8042c6:	00 00 00 
  8042c9:	be 6d 00 00 00       	mov    $0x6d,%esi
  8042ce:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  8042d5:	00 00 00 
  8042d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8042dd:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8042e4:	00 00 00 
  8042e7:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8042ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042ed:	48 63 d0             	movslq %eax,%rdx
  8042f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f4:	48 89 c6             	mov    %rax,%rsi
  8042f7:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8042fe:	00 00 00 
  804301:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804308:	00 00 00 
  80430b:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80430d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804314:	00 00 00 
  804317:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80431a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80431d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804324:	00 00 00 
  804327:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80432a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80432d:	bf 08 00 00 00       	mov    $0x8,%edi
  804332:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  804339:	00 00 00 
  80433c:	ff d0                	callq  *%rax
}
  80433e:	c9                   	leaveq 
  80433f:	c3                   	retq   

0000000000804340 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804340:	55                   	push   %rbp
  804341:	48 89 e5             	mov    %rsp,%rbp
  804344:	48 83 ec 10          	sub    $0x10,%rsp
  804348:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80434b:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80434e:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804351:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804358:	00 00 00 
  80435b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80435e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804360:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804367:	00 00 00 
  80436a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80436d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804370:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804377:	00 00 00 
  80437a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80437d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804380:	bf 09 00 00 00       	mov    $0x9,%edi
  804385:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  80438c:	00 00 00 
  80438f:	ff d0                	callq  *%rax
}
  804391:	c9                   	leaveq 
  804392:	c3                   	retq   

0000000000804393 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804393:	55                   	push   %rbp
  804394:	48 89 e5             	mov    %rsp,%rbp
  804397:	53                   	push   %rbx
  804398:	48 83 ec 38          	sub    $0x38,%rsp
  80439c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8043a0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8043a4:	48 89 c7             	mov    %rax,%rdi
  8043a7:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  8043ae:	00 00 00 
  8043b1:	ff d0                	callq  *%rax
  8043b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043ba:	0f 88 bf 01 00 00    	js     80457f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043c4:	ba 07 04 00 00       	mov    $0x407,%edx
  8043c9:	48 89 c6             	mov    %rax,%rsi
  8043cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8043d1:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  8043d8:	00 00 00 
  8043db:	ff d0                	callq  *%rax
  8043dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043e4:	0f 88 95 01 00 00    	js     80457f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8043ea:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8043ee:	48 89 c7             	mov    %rax,%rdi
  8043f1:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  8043f8:	00 00 00 
  8043fb:	ff d0                	callq  *%rax
  8043fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804400:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804404:	0f 88 5d 01 00 00    	js     804567 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80440a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80440e:	ba 07 04 00 00       	mov    $0x407,%edx
  804413:	48 89 c6             	mov    %rax,%rsi
  804416:	bf 00 00 00 00       	mov    $0x0,%edi
  80441b:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  804422:	00 00 00 
  804425:	ff d0                	callq  *%rax
  804427:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80442a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80442e:	0f 88 33 01 00 00    	js     804567 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804438:	48 89 c7             	mov    %rax,%rdi
  80443b:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  804442:	00 00 00 
  804445:	ff d0                	callq  *%rax
  804447:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80444b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444f:	ba 07 04 00 00       	mov    $0x407,%edx
  804454:	48 89 c6             	mov    %rax,%rsi
  804457:	bf 00 00 00 00       	mov    $0x0,%edi
  80445c:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  804463:	00 00 00 
  804466:	ff d0                	callq  *%rax
  804468:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80446b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80446f:	79 05                	jns    804476 <pipe+0xe3>
		goto err2;
  804471:	e9 d9 00 00 00       	jmpq   80454f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804476:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80447a:	48 89 c7             	mov    %rax,%rdi
  80447d:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  804484:	00 00 00 
  804487:	ff d0                	callq  *%rax
  804489:	48 89 c2             	mov    %rax,%rdx
  80448c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804490:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804496:	48 89 d1             	mov    %rdx,%rcx
  804499:	ba 00 00 00 00       	mov    $0x0,%edx
  80449e:	48 89 c6             	mov    %rax,%rsi
  8044a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8044a6:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  8044ad:	00 00 00 
  8044b0:	ff d0                	callq  *%rax
  8044b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044b9:	79 1b                	jns    8044d6 <pipe+0x143>
		goto err3;
  8044bb:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8044bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044c0:	48 89 c6             	mov    %rax,%rsi
  8044c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8044c8:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  8044cf:	00 00 00 
  8044d2:	ff d0                	callq  *%rax
  8044d4:	eb 79                	jmp    80454f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8044d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044da:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8044e1:	00 00 00 
  8044e4:	8b 12                	mov    (%rdx),%edx
  8044e6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8044e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8044f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044f7:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8044fe:	00 00 00 
  804501:	8b 12                	mov    (%rdx),%edx
  804503:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804505:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804509:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804514:	48 89 c7             	mov    %rax,%rdi
  804517:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  80451e:	00 00 00 
  804521:	ff d0                	callq  *%rax
  804523:	89 c2                	mov    %eax,%edx
  804525:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804529:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80452b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80452f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804537:	48 89 c7             	mov    %rax,%rdi
  80453a:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  804541:	00 00 00 
  804544:	ff d0                	callq  *%rax
  804546:	89 03                	mov    %eax,(%rbx)
	return 0;
  804548:	b8 00 00 00 00       	mov    $0x0,%eax
  80454d:	eb 33                	jmp    804582 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80454f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804553:	48 89 c6             	mov    %rax,%rsi
  804556:	bf 00 00 00 00       	mov    $0x0,%edi
  80455b:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  804562:	00 00 00 
  804565:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80456b:	48 89 c6             	mov    %rax,%rsi
  80456e:	bf 00 00 00 00       	mov    $0x0,%edi
  804573:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  80457a:	00 00 00 
  80457d:	ff d0                	callq  *%rax
err:
	return r;
  80457f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804582:	48 83 c4 38          	add    $0x38,%rsp
  804586:	5b                   	pop    %rbx
  804587:	5d                   	pop    %rbp
  804588:	c3                   	retq   

0000000000804589 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804589:	55                   	push   %rbp
  80458a:	48 89 e5             	mov    %rsp,%rbp
  80458d:	53                   	push   %rbx
  80458e:	48 83 ec 28          	sub    $0x28,%rsp
  804592:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804596:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80459a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8045a1:	00 00 00 
  8045a4:	48 8b 00             	mov    (%rax),%rax
  8045a7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8045ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8045b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045b4:	48 89 c7             	mov    %rax,%rdi
  8045b7:	48 b8 0f 4c 80 00 00 	movabs $0x804c0f,%rax
  8045be:	00 00 00 
  8045c1:	ff d0                	callq  *%rax
  8045c3:	89 c3                	mov    %eax,%ebx
  8045c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045c9:	48 89 c7             	mov    %rax,%rdi
  8045cc:	48 b8 0f 4c 80 00 00 	movabs $0x804c0f,%rax
  8045d3:	00 00 00 
  8045d6:	ff d0                	callq  *%rax
  8045d8:	39 c3                	cmp    %eax,%ebx
  8045da:	0f 94 c0             	sete   %al
  8045dd:	0f b6 c0             	movzbl %al,%eax
  8045e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8045e3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8045ea:	00 00 00 
  8045ed:	48 8b 00             	mov    (%rax),%rax
  8045f0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8045f6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8045f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045fc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8045ff:	75 05                	jne    804606 <_pipeisclosed+0x7d>
			return ret;
  804601:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804604:	eb 4f                	jmp    804655 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804609:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80460c:	74 42                	je     804650 <_pipeisclosed+0xc7>
  80460e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804612:	75 3c                	jne    804650 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804614:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80461b:	00 00 00 
  80461e:	48 8b 00             	mov    (%rax),%rax
  804621:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804627:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80462a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80462d:	89 c6                	mov    %eax,%esi
  80462f:	48 bf 95 57 80 00 00 	movabs $0x805795,%rdi
  804636:	00 00 00 
  804639:	b8 00 00 00 00       	mov    $0x0,%eax
  80463e:	49 b8 59 0f 80 00 00 	movabs $0x800f59,%r8
  804645:	00 00 00 
  804648:	41 ff d0             	callq  *%r8
	}
  80464b:	e9 4a ff ff ff       	jmpq   80459a <_pipeisclosed+0x11>
  804650:	e9 45 ff ff ff       	jmpq   80459a <_pipeisclosed+0x11>

}
  804655:	48 83 c4 28          	add    $0x28,%rsp
  804659:	5b                   	pop    %rbx
  80465a:	5d                   	pop    %rbp
  80465b:	c3                   	retq   

000000000080465c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80465c:	55                   	push   %rbp
  80465d:	48 89 e5             	mov    %rsp,%rbp
  804660:	48 83 ec 30          	sub    $0x30,%rsp
  804664:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804667:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80466b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80466e:	48 89 d6             	mov    %rdx,%rsi
  804671:	89 c7                	mov    %eax,%edi
  804673:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  80467a:	00 00 00 
  80467d:	ff d0                	callq  *%rax
  80467f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804682:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804686:	79 05                	jns    80468d <pipeisclosed+0x31>
		return r;
  804688:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468b:	eb 31                	jmp    8046be <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80468d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804691:	48 89 c7             	mov    %rax,%rdi
  804694:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  80469b:	00 00 00 
  80469e:	ff d0                	callq  *%rax
  8046a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8046a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046ac:	48 89 d6             	mov    %rdx,%rsi
  8046af:	48 89 c7             	mov    %rax,%rdi
  8046b2:	48 b8 89 45 80 00 00 	movabs $0x804589,%rax
  8046b9:	00 00 00 
  8046bc:	ff d0                	callq  *%rax
}
  8046be:	c9                   	leaveq 
  8046bf:	c3                   	retq   

00000000008046c0 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046c0:	55                   	push   %rbp
  8046c1:	48 89 e5             	mov    %rsp,%rbp
  8046c4:	48 83 ec 40          	sub    $0x40,%rsp
  8046c8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046d0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8046d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046d8:	48 89 c7             	mov    %rax,%rdi
  8046db:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  8046e2:	00 00 00 
  8046e5:	ff d0                	callq  *%rax
  8046e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8046eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8046f3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046fa:	00 
  8046fb:	e9 92 00 00 00       	jmpq   804792 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804700:	eb 41                	jmp    804743 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804702:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804707:	74 09                	je     804712 <devpipe_read+0x52>
				return i;
  804709:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80470d:	e9 92 00 00 00       	jmpq   8047a4 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804712:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80471a:	48 89 d6             	mov    %rdx,%rsi
  80471d:	48 89 c7             	mov    %rax,%rdi
  804720:	48 b8 89 45 80 00 00 	movabs $0x804589,%rax
  804727:	00 00 00 
  80472a:	ff d0                	callq  *%rax
  80472c:	85 c0                	test   %eax,%eax
  80472e:	74 07                	je     804737 <devpipe_read+0x77>
				return 0;
  804730:	b8 00 00 00 00       	mov    $0x0,%eax
  804735:	eb 6d                	jmp    8047a4 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804737:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  80473e:	00 00 00 
  804741:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804747:	8b 10                	mov    (%rax),%edx
  804749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80474d:	8b 40 04             	mov    0x4(%rax),%eax
  804750:	39 c2                	cmp    %eax,%edx
  804752:	74 ae                	je     804702 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804758:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80475c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804760:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804764:	8b 00                	mov    (%rax),%eax
  804766:	99                   	cltd   
  804767:	c1 ea 1b             	shr    $0x1b,%edx
  80476a:	01 d0                	add    %edx,%eax
  80476c:	83 e0 1f             	and    $0x1f,%eax
  80476f:	29 d0                	sub    %edx,%eax
  804771:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804775:	48 98                	cltq   
  804777:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80477c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80477e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804782:	8b 00                	mov    (%rax),%eax
  804784:	8d 50 01             	lea    0x1(%rax),%edx
  804787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80478b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80478d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804796:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80479a:	0f 82 60 ff ff ff    	jb     804700 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8047a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8047a4:	c9                   	leaveq 
  8047a5:	c3                   	retq   

00000000008047a6 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8047a6:	55                   	push   %rbp
  8047a7:	48 89 e5             	mov    %rsp,%rbp
  8047aa:	48 83 ec 40          	sub    $0x40,%rsp
  8047ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8047b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8047ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047be:	48 89 c7             	mov    %rax,%rdi
  8047c1:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  8047c8:	00 00 00 
  8047cb:	ff d0                	callq  *%rax
  8047cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8047d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8047d9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8047e0:	00 
  8047e1:	e9 8e 00 00 00       	jmpq   804874 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8047e6:	eb 31                	jmp    804819 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8047e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047f0:	48 89 d6             	mov    %rdx,%rsi
  8047f3:	48 89 c7             	mov    %rax,%rdi
  8047f6:	48 b8 89 45 80 00 00 	movabs $0x804589,%rax
  8047fd:	00 00 00 
  804800:	ff d0                	callq  *%rax
  804802:	85 c0                	test   %eax,%eax
  804804:	74 07                	je     80480d <devpipe_write+0x67>
				return 0;
  804806:	b8 00 00 00 00       	mov    $0x0,%eax
  80480b:	eb 79                	jmp    804886 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80480d:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  804814:	00 00 00 
  804817:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804819:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80481d:	8b 40 04             	mov    0x4(%rax),%eax
  804820:	48 63 d0             	movslq %eax,%rdx
  804823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804827:	8b 00                	mov    (%rax),%eax
  804829:	48 98                	cltq   
  80482b:	48 83 c0 20          	add    $0x20,%rax
  80482f:	48 39 c2             	cmp    %rax,%rdx
  804832:	73 b4                	jae    8047e8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804838:	8b 40 04             	mov    0x4(%rax),%eax
  80483b:	99                   	cltd   
  80483c:	c1 ea 1b             	shr    $0x1b,%edx
  80483f:	01 d0                	add    %edx,%eax
  804841:	83 e0 1f             	and    $0x1f,%eax
  804844:	29 d0                	sub    %edx,%eax
  804846:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80484a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80484e:	48 01 ca             	add    %rcx,%rdx
  804851:	0f b6 0a             	movzbl (%rdx),%ecx
  804854:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804858:	48 98                	cltq   
  80485a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80485e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804862:	8b 40 04             	mov    0x4(%rax),%eax
  804865:	8d 50 01             	lea    0x1(%rax),%edx
  804868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80486c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80486f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804878:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80487c:	0f 82 64 ff ff ff    	jb     8047e6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804886:	c9                   	leaveq 
  804887:	c3                   	retq   

0000000000804888 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804888:	55                   	push   %rbp
  804889:	48 89 e5             	mov    %rsp,%rbp
  80488c:	48 83 ec 20          	sub    $0x20,%rsp
  804890:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804894:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80489c:	48 89 c7             	mov    %rax,%rdi
  80489f:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  8048a6:	00 00 00 
  8048a9:	ff d0                	callq  *%rax
  8048ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8048af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048b3:	48 be a8 57 80 00 00 	movabs $0x8057a8,%rsi
  8048ba:	00 00 00 
  8048bd:	48 89 c7             	mov    %rax,%rdi
  8048c0:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8048c7:	00 00 00 
  8048ca:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8048cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d0:	8b 50 04             	mov    0x4(%rax),%edx
  8048d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d7:	8b 00                	mov    (%rax),%eax
  8048d9:	29 c2                	sub    %eax,%edx
  8048db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048df:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8048e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048e9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8048f0:	00 00 00 
	stat->st_dev = &devpipe;
  8048f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048f7:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8048fe:	00 00 00 
  804901:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804908:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80490d:	c9                   	leaveq 
  80490e:	c3                   	retq   

000000000080490f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80490f:	55                   	push   %rbp
  804910:	48 89 e5             	mov    %rsp,%rbp
  804913:	48 83 ec 10          	sub    $0x10,%rsp
  804917:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80491b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80491f:	48 89 c6             	mov    %rax,%rsi
  804922:	bf 00 00 00 00       	mov    $0x0,%edi
  804927:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  80492e:	00 00 00 
  804931:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804933:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804937:	48 89 c7             	mov    %rax,%rdi
  80493a:	48 b8 7f 2b 80 00 00 	movabs $0x802b7f,%rax
  804941:	00 00 00 
  804944:	ff d0                	callq  *%rax
  804946:	48 89 c6             	mov    %rax,%rsi
  804949:	bf 00 00 00 00       	mov    $0x0,%edi
  80494e:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  804955:	00 00 00 
  804958:	ff d0                	callq  *%rax
}
  80495a:	c9                   	leaveq 
  80495b:	c3                   	retq   

000000000080495c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80495c:	55                   	push   %rbp
  80495d:	48 89 e5             	mov    %rsp,%rbp
  804960:	48 83 ec 20          	sub    $0x20,%rsp
  804964:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804967:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80496a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80496d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804971:	be 01 00 00 00       	mov    $0x1,%esi
  804976:	48 89 c7             	mov    %rax,%rdi
  804979:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  804980:	00 00 00 
  804983:	ff d0                	callq  *%rax
}
  804985:	c9                   	leaveq 
  804986:	c3                   	retq   

0000000000804987 <getchar>:

int
getchar(void)
{
  804987:	55                   	push   %rbp
  804988:	48 89 e5             	mov    %rsp,%rbp
  80498b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80498f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804993:	ba 01 00 00 00       	mov    $0x1,%edx
  804998:	48 89 c6             	mov    %rax,%rsi
  80499b:	bf 00 00 00 00       	mov    $0x0,%edi
  8049a0:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  8049a7:	00 00 00 
  8049aa:	ff d0                	callq  *%rax
  8049ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8049af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049b3:	79 05                	jns    8049ba <getchar+0x33>
		return r;
  8049b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049b8:	eb 14                	jmp    8049ce <getchar+0x47>
	if (r < 1)
  8049ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049be:	7f 07                	jg     8049c7 <getchar+0x40>
		return -E_EOF;
  8049c0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8049c5:	eb 07                	jmp    8049ce <getchar+0x47>
	return c;
  8049c7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8049cb:	0f b6 c0             	movzbl %al,%eax

}
  8049ce:	c9                   	leaveq 
  8049cf:	c3                   	retq   

00000000008049d0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8049d0:	55                   	push   %rbp
  8049d1:	48 89 e5             	mov    %rsp,%rbp
  8049d4:	48 83 ec 20          	sub    $0x20,%rsp
  8049d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8049db:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8049df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049e2:	48 89 d6             	mov    %rdx,%rsi
  8049e5:	89 c7                	mov    %eax,%edi
  8049e7:	48 b8 42 2c 80 00 00 	movabs $0x802c42,%rax
  8049ee:	00 00 00 
  8049f1:	ff d0                	callq  *%rax
  8049f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049fa:	79 05                	jns    804a01 <iscons+0x31>
		return r;
  8049fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049ff:	eb 1a                	jmp    804a1b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a05:	8b 10                	mov    (%rax),%edx
  804a07:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804a0e:	00 00 00 
  804a11:	8b 00                	mov    (%rax),%eax
  804a13:	39 c2                	cmp    %eax,%edx
  804a15:	0f 94 c0             	sete   %al
  804a18:	0f b6 c0             	movzbl %al,%eax
}
  804a1b:	c9                   	leaveq 
  804a1c:	c3                   	retq   

0000000000804a1d <opencons>:

int
opencons(void)
{
  804a1d:	55                   	push   %rbp
  804a1e:	48 89 e5             	mov    %rsp,%rbp
  804a21:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804a25:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804a29:	48 89 c7             	mov    %rax,%rdi
  804a2c:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  804a33:	00 00 00 
  804a36:	ff d0                	callq  *%rax
  804a38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a3f:	79 05                	jns    804a46 <opencons+0x29>
		return r;
  804a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a44:	eb 5b                	jmp    804aa1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804a46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a4a:	ba 07 04 00 00       	mov    $0x407,%edx
  804a4f:	48 89 c6             	mov    %rax,%rsi
  804a52:	bf 00 00 00 00       	mov    $0x0,%edi
  804a57:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  804a5e:	00 00 00 
  804a61:	ff d0                	callq  *%rax
  804a63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a6a:	79 05                	jns    804a71 <opencons+0x54>
		return r;
  804a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a6f:	eb 30                	jmp    804aa1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804a71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a75:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804a7c:	00 00 00 
  804a7f:	8b 12                	mov    (%rdx),%edx
  804a81:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a87:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804a8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a92:	48 89 c7             	mov    %rax,%rdi
  804a95:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  804a9c:	00 00 00 
  804a9f:	ff d0                	callq  *%rax
}
  804aa1:	c9                   	leaveq 
  804aa2:	c3                   	retq   

0000000000804aa3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804aa3:	55                   	push   %rbp
  804aa4:	48 89 e5             	mov    %rsp,%rbp
  804aa7:	48 83 ec 30          	sub    $0x30,%rsp
  804aab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804aaf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804ab3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804ab7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804abc:	75 07                	jne    804ac5 <devcons_read+0x22>
		return 0;
  804abe:	b8 00 00 00 00       	mov    $0x0,%eax
  804ac3:	eb 4b                	jmp    804b10 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804ac5:	eb 0c                	jmp    804ad3 <devcons_read+0x30>
		sys_yield();
  804ac7:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  804ace:	00 00 00 
  804ad1:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804ad3:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  804ada:	00 00 00 
  804add:	ff d0                	callq  *%rax
  804adf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ae2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ae6:	74 df                	je     804ac7 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804ae8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804aec:	79 05                	jns    804af3 <devcons_read+0x50>
		return c;
  804aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804af1:	eb 1d                	jmp    804b10 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804af3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804af7:	75 07                	jne    804b00 <devcons_read+0x5d>
		return 0;
  804af9:	b8 00 00 00 00       	mov    $0x0,%eax
  804afe:	eb 10                	jmp    804b10 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b03:	89 c2                	mov    %eax,%edx
  804b05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b09:	88 10                	mov    %dl,(%rax)
	return 1;
  804b0b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804b10:	c9                   	leaveq 
  804b11:	c3                   	retq   

0000000000804b12 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804b12:	55                   	push   %rbp
  804b13:	48 89 e5             	mov    %rsp,%rbp
  804b16:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804b1d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804b24:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804b2b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804b32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804b39:	eb 76                	jmp    804bb1 <devcons_write+0x9f>
		m = n - tot;
  804b3b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804b42:	89 c2                	mov    %eax,%edx
  804b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b47:	29 c2                	sub    %eax,%edx
  804b49:	89 d0                	mov    %edx,%eax
  804b4b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804b4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b51:	83 f8 7f             	cmp    $0x7f,%eax
  804b54:	76 07                	jbe    804b5d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804b56:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804b5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b60:	48 63 d0             	movslq %eax,%rdx
  804b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b66:	48 63 c8             	movslq %eax,%rcx
  804b69:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804b70:	48 01 c1             	add    %rax,%rcx
  804b73:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b7a:	48 89 ce             	mov    %rcx,%rsi
  804b7d:	48 89 c7             	mov    %rax,%rdi
  804b80:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804b87:	00 00 00 
  804b8a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804b8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b8f:	48 63 d0             	movslq %eax,%rdx
  804b92:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b99:	48 89 d6             	mov    %rdx,%rsi
  804b9c:	48 89 c7             	mov    %rax,%rdi
  804b9f:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  804ba6:	00 00 00 
  804ba9:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804bab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804bae:	01 45 fc             	add    %eax,-0x4(%rbp)
  804bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bb4:	48 98                	cltq   
  804bb6:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804bbd:	0f 82 78 ff ff ff    	jb     804b3b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804bc6:	c9                   	leaveq 
  804bc7:	c3                   	retq   

0000000000804bc8 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804bc8:	55                   	push   %rbp
  804bc9:	48 89 e5             	mov    %rsp,%rbp
  804bcc:	48 83 ec 08          	sub    $0x8,%rsp
  804bd0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804bd9:	c9                   	leaveq 
  804bda:	c3                   	retq   

0000000000804bdb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804bdb:	55                   	push   %rbp
  804bdc:	48 89 e5             	mov    %rsp,%rbp
  804bdf:	48 83 ec 10          	sub    $0x10,%rsp
  804be3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804be7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bef:	48 be b4 57 80 00 00 	movabs $0x8057b4,%rsi
  804bf6:	00 00 00 
  804bf9:	48 89 c7             	mov    %rax,%rdi
  804bfc:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  804c03:	00 00 00 
  804c06:	ff d0                	callq  *%rax
	return 0;
  804c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c0d:	c9                   	leaveq 
  804c0e:	c3                   	retq   

0000000000804c0f <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804c0f:	55                   	push   %rbp
  804c10:	48 89 e5             	mov    %rsp,%rbp
  804c13:	48 83 ec 18          	sub    $0x18,%rsp
  804c17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c1f:	48 c1 e8 15          	shr    $0x15,%rax
  804c23:	48 89 c2             	mov    %rax,%rdx
  804c26:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c2d:	01 00 00 
  804c30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c34:	83 e0 01             	and    $0x1,%eax
  804c37:	48 85 c0             	test   %rax,%rax
  804c3a:	75 07                	jne    804c43 <pageref+0x34>
		return 0;
  804c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  804c41:	eb 53                	jmp    804c96 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804c43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c47:	48 c1 e8 0c          	shr    $0xc,%rax
  804c4b:	48 89 c2             	mov    %rax,%rdx
  804c4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c55:	01 00 00 
  804c58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c5c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c64:	83 e0 01             	and    $0x1,%eax
  804c67:	48 85 c0             	test   %rax,%rax
  804c6a:	75 07                	jne    804c73 <pageref+0x64>
		return 0;
  804c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  804c71:	eb 23                	jmp    804c96 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804c73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c77:	48 c1 e8 0c          	shr    $0xc,%rax
  804c7b:	48 89 c2             	mov    %rax,%rdx
  804c7e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804c85:	00 00 00 
  804c88:	48 c1 e2 04          	shl    $0x4,%rdx
  804c8c:	48 01 d0             	add    %rdx,%rax
  804c8f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804c93:	0f b7 c0             	movzwl %ax,%eax
}
  804c96:	c9                   	leaveq 
  804c97:	c3                   	retq   
