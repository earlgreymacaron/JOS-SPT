
vmm/guest/obj/user/echosrv:     file format elf64-x86-64


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
  80003c:	e8 f7 02 00 00       	callq  800338 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  80004f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800053:	48 89 c6             	mov    %rax,%rsi
  800056:	48 bf 00 48 80 00 00 	movabs $0x804800,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <handle_client>:

void
handle_client(int sock)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 40          	sub    $0x40,%rsp
  800087:	89 7d cc             	mov    %edi,-0x34(%rbp)
	char buffer[BUFFSIZE];
	int received = -1;
  80008a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800091:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800095:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800098:	ba 20 00 00 00       	mov    $0x20,%edx
  80009d:	48 89 ce             	mov    %rcx,%rsi
  8000a0:	89 c7                	mov    %eax,%edi
  8000a2:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b5:	79 18                	jns    8000cf <handle_client+0x50>
		die("Failed to receive initial bytes from client");
  8000b7:	48 bf 08 48 80 00 00 	movabs $0x804808,%rdi
  8000be:	00 00 00 
  8000c1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	callq  *%rax

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cd:	eb 77                	jmp    800146 <handle_client+0xc7>
  8000cf:	eb 75                	jmp    800146 <handle_client+0xc7>
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d4:	48 63 d0             	movslq %eax,%rdx
  8000d7:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8000db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8000de:	48 89 ce             	mov    %rcx,%rsi
  8000e1:	89 c7                	mov    %eax,%edi
  8000e3:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
  8000ef:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f2:	74 16                	je     80010a <handle_client+0x8b>
			die("Failed to send bytes to client");
  8000f4:	48 bf 38 48 80 00 00 	movabs $0x804838,%rdi
  8000fb:	00 00 00 
  8000fe:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800105:	00 00 00 
  800108:	ff d0                	callq  *%rax

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80010a:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  80010e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800111:	ba 20 00 00 00       	mov    $0x20,%edx
  800116:	48 89 ce             	mov    %rcx,%rsi
  800119:	89 c7                	mov    %eax,%edi
  80011b:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax
  800127:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80012a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012e:	79 16                	jns    800146 <handle_client+0xc7>
			die("Failed to receive additional bytes from client");
  800130:	48 bf 58 48 80 00 00 	movabs $0x804858,%rdi
  800137:	00 00 00 
  80013a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  800146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80014a:	7f 85                	jg     8000d1 <handle_client+0x52>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80014c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80014f:	89 c7                	mov    %eax,%edi
  800151:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax
}
  80015d:	c9                   	leaveq 
  80015e:	c3                   	retq   

000000000080015f <umain>:

void
umain(int argc, char **argv)
{
  80015f:	55                   	push   %rbp
  800160:	48 89 e5             	mov    %rsp,%rbp
  800163:	48 83 ec 70          	sub    $0x70,%rsp
  800167:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  80016a:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
	int serversock, clientsock;
	struct sockaddr_in echoserver, echoclient;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80016e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800175:	ba 06 00 00 00       	mov    $0x6,%edx
  80017a:	be 01 00 00 00       	mov    $0x1,%esi
  80017f:	bf 02 00 00 00       	mov    $0x2,%edi
  800184:	48 b8 67 31 80 00 00 	movabs $0x803167,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
  800190:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800193:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800197:	79 16                	jns    8001af <umain+0x50>
		die("Failed to create socket");
  800199:	48 bf 87 48 80 00 00 	movabs $0x804887,%rdi
  8001a0:	00 00 00 
  8001a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001af:	48 bf 9f 48 80 00 00 	movabs $0x80489f,%rdi
  8001b6:	00 00 00 
  8001b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001be:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  8001c5:	00 00 00 
  8001c8:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8001ca:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001ce:	ba 10 00 00 00       	mov    $0x10,%edx
  8001d3:	be 00 00 00 00       	mov    $0x0,%esi
  8001d8:	48 89 c7             	mov    %rax,%rdi
  8001db:	48 b8 51 13 80 00 00 	movabs $0x801351,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8001e7:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 aa 47 80 00 00 	movabs $0x8047aa,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  8001ff:	bf 07 00 00 00       	mov    $0x7,%edi
  800204:	48 b8 65 47 80 00 00 	movabs $0x804765,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	callq  *%rax
  800210:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800214:	48 bf ae 48 80 00 00 	movabs $0x8048ae,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80022f:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800233:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800236:	ba 10 00 00 00       	mov    $0x10,%edx
  80023b:	48 89 ce             	mov    %rcx,%rsi
  80023e:	89 c7                	mov    %eax,%edi
  800240:	48 b8 57 2f 80 00 00 	movabs $0x802f57,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	79 16                	jns    800266 <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800250:	48 bf c0 48 80 00 00 	movabs $0x8048c0,%rdi
  800257:	00 00 00 
  80025a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800266:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800269:	be 05 00 00 00       	mov    $0x5,%esi
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	79 16                	jns    800296 <umain+0x137>
		die("Failed to listen on server socket");
  800280:	48 bf e8 48 80 00 00 	movabs $0x8048e8,%rdi
  800287:	00 00 00 
  80028a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800291:	00 00 00 
  800294:	ff d0                	callq  *%rax

	cprintf("bound\n");
  800296:	48 bf 0a 49 80 00 00 	movabs $0x80490a,%rdi
  80029d:	00 00 00 
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a5:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  8002ac:	00 00 00 
  8002af:	ff d2                	callq  *%rdx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8002b1:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%rbp)
		// Wait for client connection
		if ((clientsock =
  8002b8:	48 8d 55 ac          	lea    -0x54(%rbp),%rdx
  8002bc:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8002c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c3:	48 89 ce             	mov    %rcx,%rsi
  8002c6:	89 c7                	mov    %eax,%edi
  8002c8:	48 b8 e8 2e 80 00 00 	movabs $0x802ee8,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	callq  *%rax
  8002d4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002db:	79 16                	jns    8002f3 <umain+0x194>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002dd:	48 bf 18 49 80 00 00 	movabs $0x804918,%rdi
  8002e4:	00 00 00 
  8002e7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8002f3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8002f6:	89 c7                	mov    %eax,%edi
  8002f8:	48 b8 33 46 80 00 00 	movabs $0x804633,%rax
  8002ff:	00 00 00 
  800302:	ff d0                	callq  *%rax
  800304:	48 89 c6             	mov    %rax,%rsi
  800307:	48 bf 3b 49 80 00 00 	movabs $0x80493b,%rdi
  80030e:	00 00 00 
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  80031d:	00 00 00 
  800320:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  800322:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800325:	89 c7                	mov    %eax,%edi
  800327:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  80032e:	00 00 00 
  800331:	ff d0                	callq  *%rax
	}
  800333:	e9 79 ff ff ff       	jmpq   8002b1 <umain+0x152>

0000000000800338 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
  80033c:	48 83 ec 10          	sub    $0x10,%rsp
  800340:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800347:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
  800353:	25 ff 03 00 00       	and    $0x3ff,%eax
  800358:	48 98                	cltq   
  80035a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800361:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800368:	00 00 00 
  80036b:	48 01 c2             	add    %rax,%rdx
  80036e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800375:	00 00 00 
  800378:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80037f:	7e 14                	jle    800395 <libmain+0x5d>
		binaryname = argv[0];
  800381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800385:	48 8b 10             	mov    (%rax),%rdx
  800388:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80038f:	00 00 00 
  800392:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800395:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039c:	48 89 d6             	mov    %rdx,%rsi
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
  8003a8:	00 00 00 
  8003ab:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003ad:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  8003b4:	00 00 00 
  8003b7:	ff d0                	callq  *%rax
}
  8003b9:	c9                   	leaveq 
  8003ba:	c3                   	retq   

00000000008003bb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003bb:	55                   	push   %rbp
  8003bc:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8003bf:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8003cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d0:	48 b8 27 19 80 00 00 	movabs $0x801927,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
}
  8003dc:	5d                   	pop    %rbp
  8003dd:	c3                   	retq   

00000000008003de <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
  8003e2:	48 83 ec 10          	sub    $0x10,%rsp
  8003e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f1:	8b 00                	mov    (%rax),%eax
  8003f3:	8d 48 01             	lea    0x1(%rax),%ecx
  8003f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003fa:	89 0a                	mov    %ecx,(%rdx)
  8003fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003ff:	89 d1                	mov    %edx,%ecx
  800401:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800405:	48 98                	cltq   
  800407:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80040b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040f:	8b 00                	mov    (%rax),%eax
  800411:	3d ff 00 00 00       	cmp    $0xff,%eax
  800416:	75 2c                	jne    800444 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041c:	8b 00                	mov    (%rax),%eax
  80041e:	48 98                	cltq   
  800420:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800424:	48 83 c2 08          	add    $0x8,%rdx
  800428:	48 89 c6             	mov    %rax,%rsi
  80042b:	48 89 d7             	mov    %rdx,%rdi
  80042e:	48 b8 9f 18 80 00 00 	movabs $0x80189f,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax
        b->idx = 0;
  80043a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800448:	8b 40 04             	mov    0x4(%rax),%eax
  80044b:	8d 50 01             	lea    0x1(%rax),%edx
  80044e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800452:	89 50 04             	mov    %edx,0x4(%rax)
}
  800455:	c9                   	leaveq 
  800456:	c3                   	retq   

0000000000800457 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800457:	55                   	push   %rbp
  800458:	48 89 e5             	mov    %rsp,%rbp
  80045b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800462:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800469:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800470:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800477:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80047e:	48 8b 0a             	mov    (%rdx),%rcx
  800481:	48 89 08             	mov    %rcx,(%rax)
  800484:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800488:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80048c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800490:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800494:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80049b:	00 00 00 
    b.cnt = 0;
  80049e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004a5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004a8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004af:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004b6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004bd:	48 89 c6             	mov    %rax,%rsi
  8004c0:	48 bf de 03 80 00 00 	movabs $0x8003de,%rdi
  8004c7:	00 00 00 
  8004ca:	48 b8 b6 08 80 00 00 	movabs $0x8008b6,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004d6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004dc:	48 98                	cltq   
  8004de:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004e5:	48 83 c2 08          	add    $0x8,%rdx
  8004e9:	48 89 c6             	mov    %rax,%rsi
  8004ec:	48 89 d7             	mov    %rdx,%rdi
  8004ef:	48 b8 9f 18 80 00 00 	movabs $0x80189f,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800501:	c9                   	leaveq 
  800502:	c3                   	retq   

0000000000800503 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800503:	55                   	push   %rbp
  800504:	48 89 e5             	mov    %rsp,%rbp
  800507:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80050e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800515:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80051c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800523:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80052a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800531:	84 c0                	test   %al,%al
  800533:	74 20                	je     800555 <cprintf+0x52>
  800535:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800539:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80053d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800541:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800545:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800549:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80054d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800551:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800555:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80055c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800563:	00 00 00 
  800566:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80056d:	00 00 00 
  800570:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800574:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80057b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800582:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800589:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800590:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800597:	48 8b 0a             	mov    (%rdx),%rcx
  80059a:	48 89 08             	mov    %rcx,(%rax)
  80059d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005a1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005a9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005ad:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005b4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005bb:	48 89 d6             	mov    %rdx,%rsi
  8005be:	48 89 c7             	mov    %rax,%rdi
  8005c1:	48 b8 57 04 80 00 00 	movabs $0x800457,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
  8005cd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005d3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005d9:	c9                   	leaveq 
  8005da:	c3                   	retq   

00000000008005db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005db:	55                   	push   %rbp
  8005dc:	48 89 e5             	mov    %rsp,%rbp
  8005df:	53                   	push   %rbx
  8005e0:	48 83 ec 38          	sub    $0x38,%rsp
  8005e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005f0:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005f3:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005f7:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005fb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005fe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800602:	77 3b                	ja     80063f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800604:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800607:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80060b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80060e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	48 f7 f3             	div    %rbx
  80061a:	48 89 c2             	mov    %rax,%rdx
  80061d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800620:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800623:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	41 89 f9             	mov    %edi,%r9d
  80062e:	48 89 c7             	mov    %rax,%rdi
  800631:	48 b8 db 05 80 00 00 	movabs $0x8005db,%rax
  800638:	00 00 00 
  80063b:	ff d0                	callq  *%rax
  80063d:	eb 1e                	jmp    80065d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063f:	eb 12                	jmp    800653 <printnum+0x78>
			putch(padc, putdat);
  800641:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800645:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 89 ce             	mov    %rcx,%rsi
  80064f:	89 d7                	mov    %edx,%edi
  800651:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800653:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800657:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80065b:	7f e4                	jg     800641 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800664:	ba 00 00 00 00       	mov    $0x0,%edx
  800669:	48 f7 f1             	div    %rcx
  80066c:	48 89 d0             	mov    %rdx,%rax
  80066f:	48 ba 50 4b 80 00 00 	movabs $0x804b50,%rdx
  800676:	00 00 00 
  800679:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80067d:	0f be d0             	movsbl %al,%edx
  800680:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 89 ce             	mov    %rcx,%rsi
  80068b:	89 d7                	mov    %edx,%edi
  80068d:	ff d0                	callq  *%rax
}
  80068f:	48 83 c4 38          	add    $0x38,%rsp
  800693:	5b                   	pop    %rbx
  800694:	5d                   	pop    %rbp
  800695:	c3                   	retq   

0000000000800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %rbp
  800697:	48 89 e5             	mov    %rsp,%rbp
  80069a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80069e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006a2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006a5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006a9:	7e 52                	jle    8006fd <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	8b 00                	mov    (%rax),%eax
  8006b1:	83 f8 30             	cmp    $0x30,%eax
  8006b4:	73 24                	jae    8006da <getuint+0x44>
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	8b 00                	mov    (%rax),%eax
  8006c4:	89 c0                	mov    %eax,%eax
  8006c6:	48 01 d0             	add    %rdx,%rax
  8006c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cd:	8b 12                	mov    (%rdx),%edx
  8006cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d6:	89 0a                	mov    %ecx,(%rdx)
  8006d8:	eb 17                	jmp    8006f1 <getuint+0x5b>
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e2:	48 89 d0             	mov    %rdx,%rax
  8006e5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ed:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f1:	48 8b 00             	mov    (%rax),%rax
  8006f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f8:	e9 a3 00 00 00       	jmpq   8007a0 <getuint+0x10a>
	else if (lflag)
  8006fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800701:	74 4f                	je     800752 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800707:	8b 00                	mov    (%rax),%eax
  800709:	83 f8 30             	cmp    $0x30,%eax
  80070c:	73 24                	jae    800732 <getuint+0x9c>
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	8b 00                	mov    (%rax),%eax
  80071c:	89 c0                	mov    %eax,%eax
  80071e:	48 01 d0             	add    %rdx,%rax
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	8b 12                	mov    (%rdx),%edx
  800727:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80072a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072e:	89 0a                	mov    %ecx,(%rdx)
  800730:	eb 17                	jmp    800749 <getuint+0xb3>
  800732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800736:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80073a:	48 89 d0             	mov    %rdx,%rax
  80073d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800741:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800745:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800749:	48 8b 00             	mov    (%rax),%rax
  80074c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800750:	eb 4e                	jmp    8007a0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800756:	8b 00                	mov    (%rax),%eax
  800758:	83 f8 30             	cmp    $0x30,%eax
  80075b:	73 24                	jae    800781 <getuint+0xeb>
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	8b 00                	mov    (%rax),%eax
  80076b:	89 c0                	mov    %eax,%eax
  80076d:	48 01 d0             	add    %rdx,%rax
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	8b 12                	mov    (%rdx),%edx
  800776:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800779:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077d:	89 0a                	mov    %ecx,(%rdx)
  80077f:	eb 17                	jmp    800798 <getuint+0x102>
  800781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800785:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800789:	48 89 d0             	mov    %rdx,%rax
  80078c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800794:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800798:	8b 00                	mov    (%rax),%eax
  80079a:	89 c0                	mov    %eax,%eax
  80079c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007a4:	c9                   	leaveq 
  8007a5:	c3                   	retq   

00000000008007a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007a6:	55                   	push   %rbp
  8007a7:	48 89 e5             	mov    %rsp,%rbp
  8007aa:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007b5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007b9:	7e 52                	jle    80080d <getint+0x67>
		x=va_arg(*ap, long long);
  8007bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bf:	8b 00                	mov    (%rax),%eax
  8007c1:	83 f8 30             	cmp    $0x30,%eax
  8007c4:	73 24                	jae    8007ea <getint+0x44>
  8007c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d2:	8b 00                	mov    (%rax),%eax
  8007d4:	89 c0                	mov    %eax,%eax
  8007d6:	48 01 d0             	add    %rdx,%rax
  8007d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dd:	8b 12                	mov    (%rdx),%edx
  8007df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e6:	89 0a                	mov    %ecx,(%rdx)
  8007e8:	eb 17                	jmp    800801 <getint+0x5b>
  8007ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f2:	48 89 d0             	mov    %rdx,%rax
  8007f5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800801:	48 8b 00             	mov    (%rax),%rax
  800804:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800808:	e9 a3 00 00 00       	jmpq   8008b0 <getint+0x10a>
	else if (lflag)
  80080d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800811:	74 4f                	je     800862 <getint+0xbc>
		x=va_arg(*ap, long);
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	8b 00                	mov    (%rax),%eax
  800819:	83 f8 30             	cmp    $0x30,%eax
  80081c:	73 24                	jae    800842 <getint+0x9c>
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	89 c0                	mov    %eax,%eax
  80082e:	48 01 d0             	add    %rdx,%rax
  800831:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800835:	8b 12                	mov    (%rdx),%edx
  800837:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	89 0a                	mov    %ecx,(%rdx)
  800840:	eb 17                	jmp    800859 <getint+0xb3>
  800842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800846:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084a:	48 89 d0             	mov    %rdx,%rax
  80084d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800851:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800855:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800859:	48 8b 00             	mov    (%rax),%rax
  80085c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800860:	eb 4e                	jmp    8008b0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800866:	8b 00                	mov    (%rax),%eax
  800868:	83 f8 30             	cmp    $0x30,%eax
  80086b:	73 24                	jae    800891 <getint+0xeb>
  80086d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800871:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	8b 00                	mov    (%rax),%eax
  80087b:	89 c0                	mov    %eax,%eax
  80087d:	48 01 d0             	add    %rdx,%rax
  800880:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800884:	8b 12                	mov    (%rdx),%edx
  800886:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800889:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088d:	89 0a                	mov    %ecx,(%rdx)
  80088f:	eb 17                	jmp    8008a8 <getint+0x102>
  800891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800895:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800899:	48 89 d0             	mov    %rdx,%rax
  80089c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a8:	8b 00                	mov    (%rax),%eax
  8008aa:	48 98                	cltq   
  8008ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b4:	c9                   	leaveq 
  8008b5:	c3                   	retq   

00000000008008b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008b6:	55                   	push   %rbp
  8008b7:	48 89 e5             	mov    %rsp,%rbp
  8008ba:	41 54                	push   %r12
  8008bc:	53                   	push   %rbx
  8008bd:	48 83 ec 60          	sub    $0x60,%rsp
  8008c1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008c5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008c9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008cd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008d1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008d5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008d9:	48 8b 0a             	mov    (%rdx),%rcx
  8008dc:	48 89 08             	mov    %rcx,(%rax)
  8008df:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008e3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008e7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008eb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ef:	eb 17                	jmp    800908 <vprintfmt+0x52>
			if (ch == '\0')
  8008f1:	85 db                	test   %ebx,%ebx
  8008f3:	0f 84 cc 04 00 00    	je     800dc5 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8008f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800901:	48 89 d6             	mov    %rdx,%rsi
  800904:	89 df                	mov    %ebx,%edi
  800906:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800908:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80090c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800910:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800914:	0f b6 00             	movzbl (%rax),%eax
  800917:	0f b6 d8             	movzbl %al,%ebx
  80091a:	83 fb 25             	cmp    $0x25,%ebx
  80091d:	75 d2                	jne    8008f1 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80091f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800923:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80092a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800931:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800938:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80093f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800943:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800947:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80094b:	0f b6 00             	movzbl (%rax),%eax
  80094e:	0f b6 d8             	movzbl %al,%ebx
  800951:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800954:	83 f8 55             	cmp    $0x55,%eax
  800957:	0f 87 34 04 00 00    	ja     800d91 <vprintfmt+0x4db>
  80095d:	89 c0                	mov    %eax,%eax
  80095f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800966:	00 
  800967:	48 b8 78 4b 80 00 00 	movabs $0x804b78,%rax
  80096e:	00 00 00 
  800971:	48 01 d0             	add    %rdx,%rax
  800974:	48 8b 00             	mov    (%rax),%rax
  800977:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800979:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80097d:	eb c0                	jmp    80093f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80097f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800983:	eb ba                	jmp    80093f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800985:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80098c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	c1 e0 02             	shl    $0x2,%eax
  800994:	01 d0                	add    %edx,%eax
  800996:	01 c0                	add    %eax,%eax
  800998:	01 d8                	add    %ebx,%eax
  80099a:	83 e8 30             	sub    $0x30,%eax
  80099d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009a0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009a4:	0f b6 00             	movzbl (%rax),%eax
  8009a7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009aa:	83 fb 2f             	cmp    $0x2f,%ebx
  8009ad:	7e 0c                	jle    8009bb <vprintfmt+0x105>
  8009af:	83 fb 39             	cmp    $0x39,%ebx
  8009b2:	7f 07                	jg     8009bb <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009b9:	eb d1                	jmp    80098c <vprintfmt+0xd6>
			goto process_precision;
  8009bb:	eb 58                	jmp    800a15 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c0:	83 f8 30             	cmp    $0x30,%eax
  8009c3:	73 17                	jae    8009dc <vprintfmt+0x126>
  8009c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cc:	89 c0                	mov    %eax,%eax
  8009ce:	48 01 d0             	add    %rdx,%rax
  8009d1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d4:	83 c2 08             	add    $0x8,%edx
  8009d7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009da:	eb 0f                	jmp    8009eb <vprintfmt+0x135>
  8009dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e0:	48 89 d0             	mov    %rdx,%rax
  8009e3:	48 83 c2 08          	add    $0x8,%rdx
  8009e7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009eb:	8b 00                	mov    (%rax),%eax
  8009ed:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009f0:	eb 23                	jmp    800a15 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f6:	79 0c                	jns    800a04 <vprintfmt+0x14e>
				width = 0;
  8009f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009ff:	e9 3b ff ff ff       	jmpq   80093f <vprintfmt+0x89>
  800a04:	e9 36 ff ff ff       	jmpq   80093f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a09:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a10:	e9 2a ff ff ff       	jmpq   80093f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a19:	79 12                	jns    800a2d <vprintfmt+0x177>
				width = precision, precision = -1;
  800a1b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a1e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a21:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a28:	e9 12 ff ff ff       	jmpq   80093f <vprintfmt+0x89>
  800a2d:	e9 0d ff ff ff       	jmpq   80093f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a32:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a36:	e9 04 ff ff ff       	jmpq   80093f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3e:	83 f8 30             	cmp    $0x30,%eax
  800a41:	73 17                	jae    800a5a <vprintfmt+0x1a4>
  800a43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4a:	89 c0                	mov    %eax,%eax
  800a4c:	48 01 d0             	add    %rdx,%rax
  800a4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a52:	83 c2 08             	add    $0x8,%edx
  800a55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a58:	eb 0f                	jmp    800a69 <vprintfmt+0x1b3>
  800a5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a5e:	48 89 d0             	mov    %rdx,%rax
  800a61:	48 83 c2 08          	add    $0x8,%rdx
  800a65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a69:	8b 10                	mov    (%rax),%edx
  800a6b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	48 89 ce             	mov    %rcx,%rsi
  800a76:	89 d7                	mov    %edx,%edi
  800a78:	ff d0                	callq  *%rax
			break;
  800a7a:	e9 40 03 00 00       	jmpq   800dbf <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a82:	83 f8 30             	cmp    $0x30,%eax
  800a85:	73 17                	jae    800a9e <vprintfmt+0x1e8>
  800a87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8e:	89 c0                	mov    %eax,%eax
  800a90:	48 01 d0             	add    %rdx,%rax
  800a93:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a96:	83 c2 08             	add    $0x8,%edx
  800a99:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a9c:	eb 0f                	jmp    800aad <vprintfmt+0x1f7>
  800a9e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa2:	48 89 d0             	mov    %rdx,%rax
  800aa5:	48 83 c2 08          	add    $0x8,%rdx
  800aa9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aad:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800aaf:	85 db                	test   %ebx,%ebx
  800ab1:	79 02                	jns    800ab5 <vprintfmt+0x1ff>
				err = -err;
  800ab3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ab5:	83 fb 15             	cmp    $0x15,%ebx
  800ab8:	7f 16                	jg     800ad0 <vprintfmt+0x21a>
  800aba:	48 b8 a0 4a 80 00 00 	movabs $0x804aa0,%rax
  800ac1:	00 00 00 
  800ac4:	48 63 d3             	movslq %ebx,%rdx
  800ac7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800acb:	4d 85 e4             	test   %r12,%r12
  800ace:	75 2e                	jne    800afe <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800ad0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad8:	89 d9                	mov    %ebx,%ecx
  800ada:	48 ba 61 4b 80 00 00 	movabs $0x804b61,%rdx
  800ae1:	00 00 00 
  800ae4:	48 89 c7             	mov    %rax,%rdi
  800ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aec:	49 b8 ce 0d 80 00 00 	movabs $0x800dce,%r8
  800af3:	00 00 00 
  800af6:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af9:	e9 c1 02 00 00       	jmpq   800dbf <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b06:	4c 89 e1             	mov    %r12,%rcx
  800b09:	48 ba 6a 4b 80 00 00 	movabs $0x804b6a,%rdx
  800b10:	00 00 00 
  800b13:	48 89 c7             	mov    %rax,%rdi
  800b16:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1b:	49 b8 ce 0d 80 00 00 	movabs $0x800dce,%r8
  800b22:	00 00 00 
  800b25:	41 ff d0             	callq  *%r8
			break;
  800b28:	e9 92 02 00 00       	jmpq   800dbf <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b30:	83 f8 30             	cmp    $0x30,%eax
  800b33:	73 17                	jae    800b4c <vprintfmt+0x296>
  800b35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3c:	89 c0                	mov    %eax,%eax
  800b3e:	48 01 d0             	add    %rdx,%rax
  800b41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b44:	83 c2 08             	add    $0x8,%edx
  800b47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b4a:	eb 0f                	jmp    800b5b <vprintfmt+0x2a5>
  800b4c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b50:	48 89 d0             	mov    %rdx,%rax
  800b53:	48 83 c2 08          	add    $0x8,%rdx
  800b57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5b:	4c 8b 20             	mov    (%rax),%r12
  800b5e:	4d 85 e4             	test   %r12,%r12
  800b61:	75 0a                	jne    800b6d <vprintfmt+0x2b7>
				p = "(null)";
  800b63:	49 bc 6d 4b 80 00 00 	movabs $0x804b6d,%r12
  800b6a:	00 00 00 
			if (width > 0 && padc != '-')
  800b6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b71:	7e 3f                	jle    800bb2 <vprintfmt+0x2fc>
  800b73:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b77:	74 39                	je     800bb2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b79:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b7c:	48 98                	cltq   
  800b7e:	48 89 c6             	mov    %rax,%rsi
  800b81:	4c 89 e7             	mov    %r12,%rdi
  800b84:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  800b8b:	00 00 00 
  800b8e:	ff d0                	callq  *%rax
  800b90:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b93:	eb 17                	jmp    800bac <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b95:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b99:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba1:	48 89 ce             	mov    %rcx,%rsi
  800ba4:	89 d7                	mov    %edx,%edi
  800ba6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb0:	7f e3                	jg     800b95 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb2:	eb 37                	jmp    800beb <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bb4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bb8:	74 1e                	je     800bd8 <vprintfmt+0x322>
  800bba:	83 fb 1f             	cmp    $0x1f,%ebx
  800bbd:	7e 05                	jle    800bc4 <vprintfmt+0x30e>
  800bbf:	83 fb 7e             	cmp    $0x7e,%ebx
  800bc2:	7e 14                	jle    800bd8 <vprintfmt+0x322>
					putch('?', putdat);
  800bc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcc:	48 89 d6             	mov    %rdx,%rsi
  800bcf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bd4:	ff d0                	callq  *%rax
  800bd6:	eb 0f                	jmp    800be7 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be0:	48 89 d6             	mov    %rdx,%rsi
  800be3:	89 df                	mov    %ebx,%edi
  800be5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800beb:	4c 89 e0             	mov    %r12,%rax
  800bee:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bf2:	0f b6 00             	movzbl (%rax),%eax
  800bf5:	0f be d8             	movsbl %al,%ebx
  800bf8:	85 db                	test   %ebx,%ebx
  800bfa:	74 10                	je     800c0c <vprintfmt+0x356>
  800bfc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c00:	78 b2                	js     800bb4 <vprintfmt+0x2fe>
  800c02:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c06:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c0a:	79 a8                	jns    800bb4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0c:	eb 16                	jmp    800c24 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c16:	48 89 d6             	mov    %rdx,%rsi
  800c19:	bf 20 00 00 00       	mov    $0x20,%edi
  800c1e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c28:	7f e4                	jg     800c0e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c2a:	e9 90 01 00 00       	jmpq   800dbf <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c33:	be 03 00 00 00       	mov    $0x3,%esi
  800c38:	48 89 c7             	mov    %rax,%rdi
  800c3b:	48 b8 a6 07 80 00 00 	movabs $0x8007a6,%rax
  800c42:	00 00 00 
  800c45:	ff d0                	callq  *%rax
  800c47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4f:	48 85 c0             	test   %rax,%rax
  800c52:	79 1d                	jns    800c71 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c64:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6a:	48 f7 d8             	neg    %rax
  800c6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c71:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c78:	e9 d5 00 00 00       	jmpq   800d52 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c81:	be 03 00 00 00       	mov    $0x3,%esi
  800c86:	48 89 c7             	mov    %rax,%rdi
  800c89:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c99:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca0:	e9 ad 00 00 00       	jmpq   800d52 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800ca5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ca9:	be 03 00 00 00       	mov    $0x3,%esi
  800cae:	48 89 c7             	mov    %rax,%rdi
  800cb1:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800cb8:	00 00 00 
  800cbb:	ff d0                	callq  *%rax
  800cbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cc1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cc8:	e9 85 00 00 00       	jmpq   800d52 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800ccd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd5:	48 89 d6             	mov    %rdx,%rsi
  800cd8:	bf 30 00 00 00       	mov    $0x30,%edi
  800cdd:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce7:	48 89 d6             	mov    %rdx,%rsi
  800cea:	bf 78 00 00 00       	mov    $0x78,%edi
  800cef:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cf1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf4:	83 f8 30             	cmp    $0x30,%eax
  800cf7:	73 17                	jae    800d10 <vprintfmt+0x45a>
  800cf9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cfd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d00:	89 c0                	mov    %eax,%eax
  800d02:	48 01 d0             	add    %rdx,%rax
  800d05:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d08:	83 c2 08             	add    $0x8,%edx
  800d0b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0e:	eb 0f                	jmp    800d1f <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d14:	48 89 d0             	mov    %rdx,%rax
  800d17:	48 83 c2 08          	add    $0x8,%rdx
  800d1b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d1f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d26:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d2d:	eb 23                	jmp    800d52 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d33:	be 03 00 00 00       	mov    $0x3,%esi
  800d38:	48 89 c7             	mov    %rax,%rdi
  800d3b:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  800d42:	00 00 00 
  800d45:	ff d0                	callq  *%rax
  800d47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d4b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d52:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d57:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d5a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d61:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d69:	45 89 c1             	mov    %r8d,%r9d
  800d6c:	41 89 f8             	mov    %edi,%r8d
  800d6f:	48 89 c7             	mov    %rax,%rdi
  800d72:	48 b8 db 05 80 00 00 	movabs $0x8005db,%rax
  800d79:	00 00 00 
  800d7c:	ff d0                	callq  *%rax
			break;
  800d7e:	eb 3f                	jmp    800dbf <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d88:	48 89 d6             	mov    %rdx,%rsi
  800d8b:	89 df                	mov    %ebx,%edi
  800d8d:	ff d0                	callq  *%rax
			break;
  800d8f:	eb 2e                	jmp    800dbf <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d99:	48 89 d6             	mov    %rdx,%rsi
  800d9c:	bf 25 00 00 00       	mov    $0x25,%edi
  800da1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800da3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da8:	eb 05                	jmp    800daf <vprintfmt+0x4f9>
  800daa:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800daf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800db3:	48 83 e8 01          	sub    $0x1,%rax
  800db7:	0f b6 00             	movzbl (%rax),%eax
  800dba:	3c 25                	cmp    $0x25,%al
  800dbc:	75 ec                	jne    800daa <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800dbe:	90                   	nop
		}
	}
  800dbf:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dc0:	e9 43 fb ff ff       	jmpq   800908 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dc5:	48 83 c4 60          	add    $0x60,%rsp
  800dc9:	5b                   	pop    %rbx
  800dca:	41 5c                	pop    %r12
  800dcc:	5d                   	pop    %rbp
  800dcd:	c3                   	retq   

0000000000800dce <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dce:	55                   	push   %rbp
  800dcf:	48 89 e5             	mov    %rsp,%rbp
  800dd2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dd9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800de0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800de7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800df5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dfc:	84 c0                	test   %al,%al
  800dfe:	74 20                	je     800e20 <printfmt+0x52>
  800e00:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e04:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e08:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e0c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e10:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e14:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e18:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e1c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e20:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e27:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e2e:	00 00 00 
  800e31:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e38:	00 00 00 
  800e3b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e3f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e46:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e4d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e54:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e5b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e62:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e69:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e70:	48 89 c7             	mov    %rax,%rdi
  800e73:	48 b8 b6 08 80 00 00 	movabs $0x8008b6,%rax
  800e7a:	00 00 00 
  800e7d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e7f:	c9                   	leaveq 
  800e80:	c3                   	retq   

0000000000800e81 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e81:	55                   	push   %rbp
  800e82:	48 89 e5             	mov    %rsp,%rbp
  800e85:	48 83 ec 10          	sub    $0x10,%rsp
  800e89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e94:	8b 40 10             	mov    0x10(%rax),%eax
  800e97:	8d 50 01             	lea    0x1(%rax),%edx
  800e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea5:	48 8b 10             	mov    (%rax),%rdx
  800ea8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eac:	48 8b 40 08          	mov    0x8(%rax),%rax
  800eb0:	48 39 c2             	cmp    %rax,%rdx
  800eb3:	73 17                	jae    800ecc <sprintputch+0x4b>
		*b->buf++ = ch;
  800eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb9:	48 8b 00             	mov    (%rax),%rax
  800ebc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ec0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ec4:	48 89 0a             	mov    %rcx,(%rdx)
  800ec7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eca:	88 10                	mov    %dl,(%rax)
}
  800ecc:	c9                   	leaveq 
  800ecd:	c3                   	retq   

0000000000800ece <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ece:	55                   	push   %rbp
  800ecf:	48 89 e5             	mov    %rsp,%rbp
  800ed2:	48 83 ec 50          	sub    $0x50,%rsp
  800ed6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eda:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800edd:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ee1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ee5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ee9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eed:	48 8b 0a             	mov    (%rdx),%rcx
  800ef0:	48 89 08             	mov    %rcx,(%rax)
  800ef3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800efb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f03:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f07:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f0b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f0e:	48 98                	cltq   
  800f10:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f14:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f18:	48 01 d0             	add    %rdx,%rax
  800f1b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f26:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f2b:	74 06                	je     800f33 <vsnprintf+0x65>
  800f2d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f31:	7f 07                	jg     800f3a <vsnprintf+0x6c>
		return -E_INVAL;
  800f33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f38:	eb 2f                	jmp    800f69 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f3a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f3e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f42:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f46:	48 89 c6             	mov    %rax,%rsi
  800f49:	48 bf 81 0e 80 00 00 	movabs $0x800e81,%rdi
  800f50:	00 00 00 
  800f53:	48 b8 b6 08 80 00 00 	movabs $0x8008b6,%rax
  800f5a:	00 00 00 
  800f5d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f63:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f66:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f69:	c9                   	leaveq 
  800f6a:	c3                   	retq   

0000000000800f6b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f6b:	55                   	push   %rbp
  800f6c:	48 89 e5             	mov    %rsp,%rbp
  800f6f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f76:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f7d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f83:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f8a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f91:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f98:	84 c0                	test   %al,%al
  800f9a:	74 20                	je     800fbc <snprintf+0x51>
  800f9c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fa0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fa4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fa8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fb0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fb4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fb8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fbc:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fc3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fca:	00 00 00 
  800fcd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fd4:	00 00 00 
  800fd7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fdb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fe2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ff0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ff7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ffe:	48 8b 0a             	mov    (%rdx),%rcx
  801001:	48 89 08             	mov    %rcx,(%rax)
  801004:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801008:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80100c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801010:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801014:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80101b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801022:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801028:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80102f:	48 89 c7             	mov    %rax,%rdi
  801032:	48 b8 ce 0e 80 00 00 	movabs $0x800ece,%rax
  801039:	00 00 00 
  80103c:	ff d0                	callq  *%rax
  80103e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801044:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 18          	sub    $0x18,%rsp
  801054:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801058:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80105f:	eb 09                	jmp    80106a <strlen+0x1e>
		n++;
  801061:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801065:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	0f b6 00             	movzbl (%rax),%eax
  801071:	84 c0                	test   %al,%al
  801073:	75 ec                	jne    801061 <strlen+0x15>
		n++;
	return n;
  801075:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 83 ec 20          	sub    $0x20,%rsp
  801082:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801086:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801091:	eb 0e                	jmp    8010a1 <strnlen+0x27>
		n++;
  801093:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801097:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80109c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010a6:	74 0b                	je     8010b3 <strnlen+0x39>
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ac:	0f b6 00             	movzbl (%rax),%eax
  8010af:	84 c0                	test   %al,%al
  8010b1:	75 e0                	jne    801093 <strnlen+0x19>
		n++;
	return n;
  8010b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010b6:	c9                   	leaveq 
  8010b7:	c3                   	retq   

00000000008010b8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b8:	55                   	push   %rbp
  8010b9:	48 89 e5             	mov    %rsp,%rbp
  8010bc:	48 83 ec 20          	sub    $0x20,%rsp
  8010c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010d0:	90                   	nop
  8010d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010dd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010e5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010e9:	0f b6 12             	movzbl (%rdx),%edx
  8010ec:	88 10                	mov    %dl,(%rax)
  8010ee:	0f b6 00             	movzbl (%rax),%eax
  8010f1:	84 c0                	test   %al,%al
  8010f3:	75 dc                	jne    8010d1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f9:	c9                   	leaveq 
  8010fa:	c3                   	retq   

00000000008010fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010fb:	55                   	push   %rbp
  8010fc:	48 89 e5             	mov    %rsp,%rbp
  8010ff:	48 83 ec 20          	sub    $0x20,%rsp
  801103:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801107:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80110b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110f:	48 89 c7             	mov    %rax,%rdi
  801112:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  801119:	00 00 00 
  80111c:	ff d0                	callq  *%rax
  80111e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801121:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801124:	48 63 d0             	movslq %eax,%rdx
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 01 c2             	add    %rax,%rdx
  80112e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801132:	48 89 c6             	mov    %rax,%rsi
  801135:	48 89 d7             	mov    %rdx,%rdi
  801138:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  80113f:	00 00 00 
  801142:	ff d0                	callq  *%rax
	return dst;
  801144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801148:	c9                   	leaveq 
  801149:	c3                   	retq   

000000000080114a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80114a:	55                   	push   %rbp
  80114b:	48 89 e5             	mov    %rsp,%rbp
  80114e:	48 83 ec 28          	sub    $0x28,%rsp
  801152:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801156:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80115a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80115e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801166:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80116d:	00 
  80116e:	eb 2a                	jmp    80119a <strncpy+0x50>
		*dst++ = *src;
  801170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801174:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801178:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80117c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801180:	0f b6 12             	movzbl (%rdx),%edx
  801183:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801185:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801189:	0f b6 00             	movzbl (%rax),%eax
  80118c:	84 c0                	test   %al,%al
  80118e:	74 05                	je     801195 <strncpy+0x4b>
			src++;
  801190:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801195:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011a2:	72 cc                	jb     801170 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011a8:	c9                   	leaveq 
  8011a9:	c3                   	retq   

00000000008011aa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011aa:	55                   	push   %rbp
  8011ab:	48 89 e5             	mov    %rsp,%rbp
  8011ae:	48 83 ec 28          	sub    $0x28,%rsp
  8011b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011cb:	74 3d                	je     80120a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011cd:	eb 1d                	jmp    8011ec <strlcpy+0x42>
			*dst++ = *src++;
  8011cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011df:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011e3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011e7:	0f b6 12             	movzbl (%rdx),%edx
  8011ea:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ec:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011f1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f6:	74 0b                	je     801203 <strlcpy+0x59>
  8011f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011fc:	0f b6 00             	movzbl (%rax),%eax
  8011ff:	84 c0                	test   %al,%al
  801201:	75 cc                	jne    8011cf <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801207:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80120a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801212:	48 29 c2             	sub    %rax,%rdx
  801215:	48 89 d0             	mov    %rdx,%rax
}
  801218:	c9                   	leaveq 
  801219:	c3                   	retq   

000000000080121a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	48 83 ec 10          	sub    $0x10,%rsp
  801222:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801226:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80122a:	eb 0a                	jmp    801236 <strcmp+0x1c>
		p++, q++;
  80122c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801231:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123a:	0f b6 00             	movzbl (%rax),%eax
  80123d:	84 c0                	test   %al,%al
  80123f:	74 12                	je     801253 <strcmp+0x39>
  801241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801245:	0f b6 10             	movzbl (%rax),%edx
  801248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124c:	0f b6 00             	movzbl (%rax),%eax
  80124f:	38 c2                	cmp    %al,%dl
  801251:	74 d9                	je     80122c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801257:	0f b6 00             	movzbl (%rax),%eax
  80125a:	0f b6 d0             	movzbl %al,%edx
  80125d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801261:	0f b6 00             	movzbl (%rax),%eax
  801264:	0f b6 c0             	movzbl %al,%eax
  801267:	29 c2                	sub    %eax,%edx
  801269:	89 d0                	mov    %edx,%eax
}
  80126b:	c9                   	leaveq 
  80126c:	c3                   	retq   

000000000080126d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80126d:	55                   	push   %rbp
  80126e:	48 89 e5             	mov    %rsp,%rbp
  801271:	48 83 ec 18          	sub    $0x18,%rsp
  801275:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801279:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80127d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801281:	eb 0f                	jmp    801292 <strncmp+0x25>
		n--, p++, q++;
  801283:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801288:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801292:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801297:	74 1d                	je     8012b6 <strncmp+0x49>
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	84 c0                	test   %al,%al
  8012a2:	74 12                	je     8012b6 <strncmp+0x49>
  8012a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a8:	0f b6 10             	movzbl (%rax),%edx
  8012ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012af:	0f b6 00             	movzbl (%rax),%eax
  8012b2:	38 c2                	cmp    %al,%dl
  8012b4:	74 cd                	je     801283 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012bb:	75 07                	jne    8012c4 <strncmp+0x57>
		return 0;
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c2:	eb 18                	jmp    8012dc <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	0f b6 d0             	movzbl %al,%edx
  8012ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d2:	0f b6 00             	movzbl (%rax),%eax
  8012d5:	0f b6 c0             	movzbl %al,%eax
  8012d8:	29 c2                	sub    %eax,%edx
  8012da:	89 d0                	mov    %edx,%eax
}
  8012dc:	c9                   	leaveq 
  8012dd:	c3                   	retq   

00000000008012de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012de:	55                   	push   %rbp
  8012df:	48 89 e5             	mov    %rsp,%rbp
  8012e2:	48 83 ec 0c          	sub    $0xc,%rsp
  8012e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ea:	89 f0                	mov    %esi,%eax
  8012ec:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ef:	eb 17                	jmp    801308 <strchr+0x2a>
		if (*s == c)
  8012f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012fb:	75 06                	jne    801303 <strchr+0x25>
			return (char *) s;
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801301:	eb 15                	jmp    801318 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801303:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130c:	0f b6 00             	movzbl (%rax),%eax
  80130f:	84 c0                	test   %al,%al
  801311:	75 de                	jne    8012f1 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801318:	c9                   	leaveq 
  801319:	c3                   	retq   

000000000080131a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80131a:	55                   	push   %rbp
  80131b:	48 89 e5             	mov    %rsp,%rbp
  80131e:	48 83 ec 0c          	sub    $0xc,%rsp
  801322:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801326:	89 f0                	mov    %esi,%eax
  801328:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80132b:	eb 13                	jmp    801340 <strfind+0x26>
		if (*s == c)
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	0f b6 00             	movzbl (%rax),%eax
  801334:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801337:	75 02                	jne    80133b <strfind+0x21>
			break;
  801339:	eb 10                	jmp    80134b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80133b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	0f b6 00             	movzbl (%rax),%eax
  801347:	84 c0                	test   %al,%al
  801349:	75 e2                	jne    80132d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80134f:	c9                   	leaveq 
  801350:	c3                   	retq   

0000000000801351 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801351:	55                   	push   %rbp
  801352:	48 89 e5             	mov    %rsp,%rbp
  801355:	48 83 ec 18          	sub    $0x18,%rsp
  801359:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801360:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801364:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801369:	75 06                	jne    801371 <memset+0x20>
		return v;
  80136b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136f:	eb 69                	jmp    8013da <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801375:	83 e0 03             	and    $0x3,%eax
  801378:	48 85 c0             	test   %rax,%rax
  80137b:	75 48                	jne    8013c5 <memset+0x74>
  80137d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801381:	83 e0 03             	and    $0x3,%eax
  801384:	48 85 c0             	test   %rax,%rax
  801387:	75 3c                	jne    8013c5 <memset+0x74>
		c &= 0xFF;
  801389:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801390:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801393:	c1 e0 18             	shl    $0x18,%eax
  801396:	89 c2                	mov    %eax,%edx
  801398:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139b:	c1 e0 10             	shl    $0x10,%eax
  80139e:	09 c2                	or     %eax,%edx
  8013a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a3:	c1 e0 08             	shl    $0x8,%eax
  8013a6:	09 d0                	or     %edx,%eax
  8013a8:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013af:	48 c1 e8 02          	shr    $0x2,%rax
  8013b3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013bd:	48 89 d7             	mov    %rdx,%rdi
  8013c0:	fc                   	cld    
  8013c1:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013c3:	eb 11                	jmp    8013d6 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013cc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013d0:	48 89 d7             	mov    %rdx,%rdi
  8013d3:	fc                   	cld    
  8013d4:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013da:	c9                   	leaveq 
  8013db:	c3                   	retq   

00000000008013dc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013dc:	55                   	push   %rbp
  8013dd:	48 89 e5             	mov    %rsp,%rbp
  8013e0:	48 83 ec 28          	sub    $0x28,%rsp
  8013e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801408:	0f 83 88 00 00 00    	jae    801496 <memmove+0xba>
  80140e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801412:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801416:	48 01 d0             	add    %rdx,%rax
  801419:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80141d:	76 77                	jbe    801496 <memmove+0xba>
		s += n;
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801427:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	83 e0 03             	and    $0x3,%eax
  801436:	48 85 c0             	test   %rax,%rax
  801439:	75 3b                	jne    801476 <memmove+0x9a>
  80143b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143f:	83 e0 03             	and    $0x3,%eax
  801442:	48 85 c0             	test   %rax,%rax
  801445:	75 2f                	jne    801476 <memmove+0x9a>
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	75 23                	jne    801476 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801457:	48 83 e8 04          	sub    $0x4,%rax
  80145b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145f:	48 83 ea 04          	sub    $0x4,%rdx
  801463:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801467:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80146b:	48 89 c7             	mov    %rax,%rdi
  80146e:	48 89 d6             	mov    %rdx,%rsi
  801471:	fd                   	std    
  801472:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801474:	eb 1d                	jmp    801493 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801482:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	48 89 d7             	mov    %rdx,%rdi
  80148d:	48 89 c1             	mov    %rax,%rcx
  801490:	fd                   	std    
  801491:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801493:	fc                   	cld    
  801494:	eb 57                	jmp    8014ed <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149a:	83 e0 03             	and    $0x3,%eax
  80149d:	48 85 c0             	test   %rax,%rax
  8014a0:	75 36                	jne    8014d8 <memmove+0xfc>
  8014a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a6:	83 e0 03             	and    $0x3,%eax
  8014a9:	48 85 c0             	test   %rax,%rax
  8014ac:	75 2a                	jne    8014d8 <memmove+0xfc>
  8014ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b2:	83 e0 03             	and    $0x3,%eax
  8014b5:	48 85 c0             	test   %rax,%rax
  8014b8:	75 1e                	jne    8014d8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014be:	48 c1 e8 02          	shr    $0x2,%rax
  8014c2:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014cd:	48 89 c7             	mov    %rax,%rdi
  8014d0:	48 89 d6             	mov    %rdx,%rsi
  8014d3:	fc                   	cld    
  8014d4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014d6:	eb 15                	jmp    8014ed <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014e4:	48 89 c7             	mov    %rax,%rdi
  8014e7:	48 89 d6             	mov    %rdx,%rsi
  8014ea:	fc                   	cld    
  8014eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014f1:	c9                   	leaveq 
  8014f2:	c3                   	retq   

00000000008014f3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014f3:	55                   	push   %rbp
  8014f4:	48 89 e5             	mov    %rsp,%rbp
  8014f7:	48 83 ec 18          	sub    $0x18,%rsp
  8014fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801503:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80150b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	48 89 ce             	mov    %rcx,%rsi
  801516:	48 89 c7             	mov    %rax,%rdi
  801519:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  801520:	00 00 00 
  801523:	ff d0                	callq  *%rax
}
  801525:	c9                   	leaveq 
  801526:	c3                   	retq   

0000000000801527 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801527:	55                   	push   %rbp
  801528:	48 89 e5             	mov    %rsp,%rbp
  80152b:	48 83 ec 28          	sub    $0x28,%rsp
  80152f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801533:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801537:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801543:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801547:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80154b:	eb 36                	jmp    801583 <memcmp+0x5c>
		if (*s1 != *s2)
  80154d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801551:	0f b6 10             	movzbl (%rax),%edx
  801554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	38 c2                	cmp    %al,%dl
  80155d:	74 1a                	je     801579 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80155f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	0f b6 d0             	movzbl %al,%edx
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	0f b6 c0             	movzbl %al,%eax
  801573:	29 c2                	sub    %eax,%edx
  801575:	89 d0                	mov    %edx,%eax
  801577:	eb 20                	jmp    801599 <memcmp+0x72>
		s1++, s2++;
  801579:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80157e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80158b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80158f:	48 85 c0             	test   %rax,%rax
  801592:	75 b9                	jne    80154d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leaveq 
  80159a:	c3                   	retq   

000000000080159b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80159b:	55                   	push   %rbp
  80159c:	48 89 e5             	mov    %rsp,%rbp
  80159f:	48 83 ec 28          	sub    $0x28,%rsp
  8015a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015a7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b6:	48 01 d0             	add    %rdx,%rax
  8015b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015bd:	eb 15                	jmp    8015d4 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c3:	0f b6 10             	movzbl (%rax),%edx
  8015c6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015c9:	38 c2                	cmp    %al,%dl
  8015cb:	75 02                	jne    8015cf <memfind+0x34>
			break;
  8015cd:	eb 0f                	jmp    8015de <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015cf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015dc:	72 e1                	jb     8015bf <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e2:	c9                   	leaveq 
  8015e3:	c3                   	retq   

00000000008015e4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015e4:	55                   	push   %rbp
  8015e5:	48 89 e5             	mov    %rsp,%rbp
  8015e8:	48 83 ec 34          	sub    $0x34,%rsp
  8015ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015f4:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015fe:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801605:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801606:	eb 05                	jmp    80160d <strtol+0x29>
		s++;
  801608:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 20                	cmp    $0x20,%al
  801616:	74 f0                	je     801608 <strtol+0x24>
  801618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161c:	0f b6 00             	movzbl (%rax),%eax
  80161f:	3c 09                	cmp    $0x9,%al
  801621:	74 e5                	je     801608 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	3c 2b                	cmp    $0x2b,%al
  80162c:	75 07                	jne    801635 <strtol+0x51>
		s++;
  80162e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801633:	eb 17                	jmp    80164c <strtol+0x68>
	else if (*s == '-')
  801635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	3c 2d                	cmp    $0x2d,%al
  80163e:	75 0c                	jne    80164c <strtol+0x68>
		s++, neg = 1;
  801640:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801645:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80164c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801650:	74 06                	je     801658 <strtol+0x74>
  801652:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801656:	75 28                	jne    801680 <strtol+0x9c>
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	3c 30                	cmp    $0x30,%al
  801661:	75 1d                	jne    801680 <strtol+0x9c>
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	48 83 c0 01          	add    $0x1,%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3c 78                	cmp    $0x78,%al
  801670:	75 0e                	jne    801680 <strtol+0x9c>
		s += 2, base = 16;
  801672:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801677:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80167e:	eb 2c                	jmp    8016ac <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801680:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801684:	75 19                	jne    80169f <strtol+0xbb>
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	3c 30                	cmp    $0x30,%al
  80168f:	75 0e                	jne    80169f <strtol+0xbb>
		s++, base = 8;
  801691:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801696:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80169d:	eb 0d                	jmp    8016ac <strtol+0xc8>
	else if (base == 0)
  80169f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016a3:	75 07                	jne    8016ac <strtol+0xc8>
		base = 10;
  8016a5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	3c 2f                	cmp    $0x2f,%al
  8016b5:	7e 1d                	jle    8016d4 <strtol+0xf0>
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	3c 39                	cmp    $0x39,%al
  8016c0:	7f 12                	jg     8016d4 <strtol+0xf0>
			dig = *s - '0';
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	0f be c0             	movsbl %al,%eax
  8016cc:	83 e8 30             	sub    $0x30,%eax
  8016cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d2:	eb 4e                	jmp    801722 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	3c 60                	cmp    $0x60,%al
  8016dd:	7e 1d                	jle    8016fc <strtol+0x118>
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	3c 7a                	cmp    $0x7a,%al
  8016e8:	7f 12                	jg     8016fc <strtol+0x118>
			dig = *s - 'a' + 10;
  8016ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ee:	0f b6 00             	movzbl (%rax),%eax
  8016f1:	0f be c0             	movsbl %al,%eax
  8016f4:	83 e8 57             	sub    $0x57,%eax
  8016f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016fa:	eb 26                	jmp    801722 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	3c 40                	cmp    $0x40,%al
  801705:	7e 48                	jle    80174f <strtol+0x16b>
  801707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170b:	0f b6 00             	movzbl (%rax),%eax
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 3d                	jg     80174f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	0f be c0             	movsbl %al,%eax
  80171c:	83 e8 37             	sub    $0x37,%eax
  80171f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801722:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801725:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801728:	7c 02                	jl     80172c <strtol+0x148>
			break;
  80172a:	eb 23                	jmp    80174f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80172c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801731:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801734:	48 98                	cltq   
  801736:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80173b:	48 89 c2             	mov    %rax,%rdx
  80173e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801741:	48 98                	cltq   
  801743:	48 01 d0             	add    %rdx,%rax
  801746:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80174a:	e9 5d ff ff ff       	jmpq   8016ac <strtol+0xc8>

	if (endptr)
  80174f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801754:	74 0b                	je     801761 <strtol+0x17d>
		*endptr = (char *) s;
  801756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80175e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801765:	74 09                	je     801770 <strtol+0x18c>
  801767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80176b:	48 f7 d8             	neg    %rax
  80176e:	eb 04                	jmp    801774 <strtol+0x190>
  801770:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801774:	c9                   	leaveq 
  801775:	c3                   	retq   

0000000000801776 <strstr>:

char * strstr(const char *in, const char *str)
{
  801776:	55                   	push   %rbp
  801777:	48 89 e5             	mov    %rsp,%rbp
  80177a:	48 83 ec 30          	sub    $0x30,%rsp
  80177e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801782:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801786:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80178e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801792:	0f b6 00             	movzbl (%rax),%eax
  801795:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801798:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80179c:	75 06                	jne    8017a4 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	eb 6b                	jmp    80180f <strstr+0x99>

	len = strlen(str);
  8017a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a8:	48 89 c7             	mov    %rax,%rdi
  8017ab:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8017b2:	00 00 00 
  8017b5:	ff d0                	callq  *%rax
  8017b7:	48 98                	cltq   
  8017b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017c9:	0f b6 00             	movzbl (%rax),%eax
  8017cc:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017cf:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017d3:	75 07                	jne    8017dc <strstr+0x66>
				return (char *) 0;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	eb 33                	jmp    80180f <strstr+0x99>
		} while (sc != c);
  8017dc:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017e0:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017e3:	75 d8                	jne    8017bd <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	48 89 ce             	mov    %rcx,%rsi
  8017f4:	48 89 c7             	mov    %rax,%rdi
  8017f7:	48 b8 6d 12 80 00 00 	movabs $0x80126d,%rax
  8017fe:	00 00 00 
  801801:	ff d0                	callq  *%rax
  801803:	85 c0                	test   %eax,%eax
  801805:	75 b6                	jne    8017bd <strstr+0x47>

	return (char *) (in - 1);
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	48 83 e8 01          	sub    $0x1,%rax
}
  80180f:	c9                   	leaveq 
  801810:	c3                   	retq   

0000000000801811 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801811:	55                   	push   %rbp
  801812:	48 89 e5             	mov    %rsp,%rbp
  801815:	53                   	push   %rbx
  801816:	48 83 ec 48          	sub    $0x48,%rsp
  80181a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80181d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801820:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801824:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801828:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80182c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801830:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801833:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801837:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80183b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80183f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801843:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801847:	4c 89 c3             	mov    %r8,%rbx
  80184a:	cd 30                	int    $0x30
  80184c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801850:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801854:	74 3e                	je     801894 <syscall+0x83>
  801856:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80185b:	7e 37                	jle    801894 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80185d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801861:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801864:	49 89 d0             	mov    %rdx,%r8
  801867:	89 c1                	mov    %eax,%ecx
  801869:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  801870:	00 00 00 
  801873:	be 24 00 00 00       	mov    $0x24,%esi
  801878:	48 bf 45 4e 80 00 00 	movabs $0x804e45,%rdi
  80187f:	00 00 00 
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
  801887:	49 b9 7a 3e 80 00 00 	movabs $0x803e7a,%r9
  80188e:	00 00 00 
  801891:	41 ff d1             	callq  *%r9

	return ret;
  801894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801898:	48 83 c4 48          	add    $0x48,%rsp
  80189c:	5b                   	pop    %rbx
  80189d:	5d                   	pop    %rbp
  80189e:	c3                   	retq   

000000000080189f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80189f:	55                   	push   %rbp
  8018a0:	48 89 e5             	mov    %rsp,%rbp
  8018a3:	48 83 ec 20          	sub    $0x20,%rsp
  8018a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018be:	00 
  8018bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cb:	48 89 d1             	mov    %rdx,%rcx
  8018ce:	48 89 c2             	mov    %rax,%rdx
  8018d1:	be 00 00 00 00       	mov    $0x0,%esi
  8018d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8018db:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  8018e2:	00 00 00 
  8018e5:	ff d0                	callq  *%rax
}
  8018e7:	c9                   	leaveq 
  8018e8:	c3                   	retq   

00000000008018e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
  8018ed:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f8:	00 
  8018f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801905:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190a:	ba 00 00 00 00       	mov    $0x0,%edx
  80190f:	be 00 00 00 00       	mov    $0x0,%esi
  801914:	bf 01 00 00 00       	mov    $0x1,%edi
  801919:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801920:	00 00 00 
  801923:	ff d0                	callq  *%rax
}
  801925:	c9                   	leaveq 
  801926:	c3                   	retq   

0000000000801927 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801927:	55                   	push   %rbp
  801928:	48 89 e5             	mov    %rsp,%rbp
  80192b:	48 83 ec 10          	sub    $0x10,%rsp
  80192f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801935:	48 98                	cltq   
  801937:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193e:	00 
  80193f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801945:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801950:	48 89 c2             	mov    %rax,%rdx
  801953:	be 01 00 00 00       	mov    $0x1,%esi
  801958:	bf 03 00 00 00       	mov    $0x3,%edi
  80195d:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801964:	00 00 00 
  801967:	ff d0                	callq  *%rax
}
  801969:	c9                   	leaveq 
  80196a:	c3                   	retq   

000000000080196b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801973:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197a:	00 
  80197b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801981:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801987:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198c:	ba 00 00 00 00       	mov    $0x0,%edx
  801991:	be 00 00 00 00       	mov    $0x0,%esi
  801996:	bf 02 00 00 00       	mov    $0x2,%edi
  80199b:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	callq  *%rax
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <sys_yield>:


void
sys_yield(void)
{
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b8:	00 
  8019b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cf:	be 00 00 00 00       	mov    $0x0,%esi
  8019d4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019d9:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  8019e0:	00 00 00 
  8019e3:	ff d0                	callq  *%rax
}
  8019e5:	c9                   	leaveq 
  8019e6:	c3                   	retq   

00000000008019e7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019e7:	55                   	push   %rbp
  8019e8:	48 89 e5             	mov    %rsp,%rbp
  8019eb:	48 83 ec 20          	sub    $0x20,%rsp
  8019ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019fc:	48 63 c8             	movslq %eax,%rcx
  8019ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a06:	48 98                	cltq   
  801a08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0f:	00 
  801a10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a16:	49 89 c8             	mov    %rcx,%r8
  801a19:	48 89 d1             	mov    %rdx,%rcx
  801a1c:	48 89 c2             	mov    %rax,%rdx
  801a1f:	be 01 00 00 00       	mov    $0x1,%esi
  801a24:	bf 04 00 00 00       	mov    $0x4,%edi
  801a29:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
}
  801a35:	c9                   	leaveq 
  801a36:	c3                   	retq   

0000000000801a37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a37:	55                   	push   %rbp
  801a38:	48 89 e5             	mov    %rsp,%rbp
  801a3b:	48 83 ec 30          	sub    $0x30,%rsp
  801a3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a46:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a49:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a4d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a51:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a54:	48 63 c8             	movslq %eax,%rcx
  801a57:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a5e:	48 63 f0             	movslq %eax,%rsi
  801a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a68:	48 98                	cltq   
  801a6a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a6e:	49 89 f9             	mov    %rdi,%r9
  801a71:	49 89 f0             	mov    %rsi,%r8
  801a74:	48 89 d1             	mov    %rdx,%rcx
  801a77:	48 89 c2             	mov    %rax,%rdx
  801a7a:	be 01 00 00 00       	mov    $0x1,%esi
  801a7f:	bf 05 00 00 00       	mov    $0x5,%edi
  801a84:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801a8b:	00 00 00 
  801a8e:	ff d0                	callq  *%rax
}
  801a90:	c9                   	leaveq 
  801a91:	c3                   	retq   

0000000000801a92 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a92:	55                   	push   %rbp
  801a93:	48 89 e5             	mov    %rsp,%rbp
  801a96:	48 83 ec 20          	sub    $0x20,%rsp
  801a9a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801aa1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa8:	48 98                	cltq   
  801aaa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab1:	00 
  801ab2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abe:	48 89 d1             	mov    %rdx,%rcx
  801ac1:	48 89 c2             	mov    %rax,%rdx
  801ac4:	be 01 00 00 00       	mov    $0x1,%esi
  801ac9:	bf 06 00 00 00       	mov    $0x6,%edi
  801ace:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
}
  801ada:	c9                   	leaveq 
  801adb:	c3                   	retq   

0000000000801adc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	48 83 ec 10          	sub    $0x10,%rsp
  801ae4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801aea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aed:	48 63 d0             	movslq %eax,%rdx
  801af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af3:	48 98                	cltq   
  801af5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afc:	00 
  801afd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b09:	48 89 d1             	mov    %rdx,%rcx
  801b0c:	48 89 c2             	mov    %rax,%rdx
  801b0f:	be 01 00 00 00       	mov    $0x1,%esi
  801b14:	bf 08 00 00 00       	mov    $0x8,%edi
  801b19:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801b20:	00 00 00 
  801b23:	ff d0                	callq  *%rax
}
  801b25:	c9                   	leaveq 
  801b26:	c3                   	retq   

0000000000801b27 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b27:	55                   	push   %rbp
  801b28:	48 89 e5             	mov    %rsp,%rbp
  801b2b:	48 83 ec 20          	sub    $0x20,%rsp
  801b2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3d:	48 98                	cltq   
  801b3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b46:	00 
  801b47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b53:	48 89 d1             	mov    %rdx,%rcx
  801b56:	48 89 c2             	mov    %rax,%rdx
  801b59:	be 01 00 00 00       	mov    $0x1,%esi
  801b5e:	bf 09 00 00 00       	mov    $0x9,%edi
  801b63:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801b6a:	00 00 00 
  801b6d:	ff d0                	callq  *%rax
}
  801b6f:	c9                   	leaveq 
  801b70:	c3                   	retq   

0000000000801b71 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b71:	55                   	push   %rbp
  801b72:	48 89 e5             	mov    %rsp,%rbp
  801b75:	48 83 ec 20          	sub    $0x20,%rsp
  801b79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b87:	48 98                	cltq   
  801b89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b90:	00 
  801b91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9d:	48 89 d1             	mov    %rdx,%rcx
  801ba0:	48 89 c2             	mov    %rax,%rdx
  801ba3:	be 01 00 00 00       	mov    $0x1,%esi
  801ba8:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bad:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	callq  *%rax
}
  801bb9:	c9                   	leaveq 
  801bba:	c3                   	retq   

0000000000801bbb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bbb:	55                   	push   %rbp
  801bbc:	48 89 e5             	mov    %rsp,%rbp
  801bbf:	48 83 ec 20          	sub    $0x20,%rsp
  801bc3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bce:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd4:	48 63 f0             	movslq %eax,%rsi
  801bd7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bde:	48 98                	cltq   
  801be0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801beb:	00 
  801bec:	49 89 f1             	mov    %rsi,%r9
  801bef:	49 89 c8             	mov    %rcx,%r8
  801bf2:	48 89 d1             	mov    %rdx,%rcx
  801bf5:	48 89 c2             	mov    %rax,%rdx
  801bf8:	be 00 00 00 00       	mov    $0x0,%esi
  801bfd:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c02:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	callq  *%rax
}
  801c0e:	c9                   	leaveq 
  801c0f:	c3                   	retq   

0000000000801c10 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c10:	55                   	push   %rbp
  801c11:	48 89 e5             	mov    %rsp,%rbp
  801c14:	48 83 ec 10          	sub    $0x10,%rsp
  801c18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c27:	00 
  801c28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c34:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c39:	48 89 c2             	mov    %rax,%rdx
  801c3c:	be 01 00 00 00       	mov    $0x1,%esi
  801c41:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c46:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801c4d:	00 00 00 
  801c50:	ff d0                	callq  *%rax
}
  801c52:	c9                   	leaveq 
  801c53:	c3                   	retq   

0000000000801c54 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c54:	55                   	push   %rbp
  801c55:	48 89 e5             	mov    %rsp,%rbp
  801c58:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c63:	00 
  801c64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c70:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c75:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7a:	be 00 00 00 00       	mov    $0x0,%esi
  801c7f:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c84:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
}
  801c90:	c9                   	leaveq 
  801c91:	c3                   	retq   

0000000000801c92 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801c92:	55                   	push   %rbp
  801c93:	48 89 e5             	mov    %rsp,%rbp
  801c96:	48 83 ec 20          	sub    $0x20,%rsp
  801c9a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c9e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801ca1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ca4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801caf:	00 
  801cb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbc:	48 89 d1             	mov    %rdx,%rcx
  801cbf:	48 89 c2             	mov    %rax,%rdx
  801cc2:	be 00 00 00 00       	mov    $0x0,%esi
  801cc7:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ccc:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 20          	sub    $0x20,%rsp
  801ce2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ce6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801ce9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf7:	00 
  801cf8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d04:	48 89 d1             	mov    %rdx,%rcx
  801d07:	48 89 c2             	mov    %rax,%rdx
  801d0a:	be 00 00 00 00       	mov    $0x0,%esi
  801d0f:	bf 10 00 00 00       	mov    $0x10,%edi
  801d14:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801d1b:	00 00 00 
  801d1e:	ff d0                	callq  *%rax
}
  801d20:	c9                   	leaveq 
  801d21:	c3                   	retq   

0000000000801d22 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d22:	55                   	push   %rbp
  801d23:	48 89 e5             	mov    %rsp,%rbp
  801d26:	48 83 ec 30          	sub    $0x30,%rsp
  801d2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d31:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d34:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d38:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d3c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d3f:	48 63 c8             	movslq %eax,%rcx
  801d42:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d49:	48 63 f0             	movslq %eax,%rsi
  801d4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d53:	48 98                	cltq   
  801d55:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d59:	49 89 f9             	mov    %rdi,%r9
  801d5c:	49 89 f0             	mov    %rsi,%r8
  801d5f:	48 89 d1             	mov    %rdx,%rcx
  801d62:	48 89 c2             	mov    %rax,%rdx
  801d65:	be 00 00 00 00       	mov    $0x0,%esi
  801d6a:	bf 11 00 00 00       	mov    $0x11,%edi
  801d6f:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801d76:	00 00 00 
  801d79:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d7b:	c9                   	leaveq 
  801d7c:	c3                   	retq   

0000000000801d7d <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d7d:	55                   	push   %rbp
  801d7e:	48 89 e5             	mov    %rsp,%rbp
  801d81:	48 83 ec 20          	sub    $0x20,%rsp
  801d85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d95:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d9c:	00 
  801d9d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da9:	48 89 d1             	mov    %rdx,%rcx
  801dac:	48 89 c2             	mov    %rax,%rdx
  801daf:	be 00 00 00 00       	mov    $0x0,%esi
  801db4:	bf 12 00 00 00       	mov    $0x12,%edi
  801db9:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  801dc0:	00 00 00 
  801dc3:	ff d0                	callq  *%rax
}
  801dc5:	c9                   	leaveq 
  801dc6:	c3                   	retq   

0000000000801dc7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dc7:	55                   	push   %rbp
  801dc8:	48 89 e5             	mov    %rsp,%rbp
  801dcb:	48 83 ec 08          	sub    $0x8,%rsp
  801dcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dd3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dd7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dde:	ff ff ff 
  801de1:	48 01 d0             	add    %rdx,%rax
  801de4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801de8:	c9                   	leaveq 
  801de9:	c3                   	retq   

0000000000801dea <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dea:	55                   	push   %rbp
  801deb:	48 89 e5             	mov    %rsp,%rbp
  801dee:	48 83 ec 08          	sub    $0x8,%rsp
  801df2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801df6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfa:	48 89 c7             	mov    %rax,%rdi
  801dfd:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  801e04:	00 00 00 
  801e07:	ff d0                	callq  *%rax
  801e09:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e0f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e13:	c9                   	leaveq 
  801e14:	c3                   	retq   

0000000000801e15 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e15:	55                   	push   %rbp
  801e16:	48 89 e5             	mov    %rsp,%rbp
  801e19:	48 83 ec 18          	sub    $0x18,%rsp
  801e1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e28:	eb 6b                	jmp    801e95 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2d:	48 98                	cltq   
  801e2f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e35:	48 c1 e0 0c          	shl    $0xc,%rax
  801e39:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e41:	48 c1 e8 15          	shr    $0x15,%rax
  801e45:	48 89 c2             	mov    %rax,%rdx
  801e48:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e4f:	01 00 00 
  801e52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e56:	83 e0 01             	and    $0x1,%eax
  801e59:	48 85 c0             	test   %rax,%rax
  801e5c:	74 21                	je     801e7f <fd_alloc+0x6a>
  801e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e62:	48 c1 e8 0c          	shr    $0xc,%rax
  801e66:	48 89 c2             	mov    %rax,%rdx
  801e69:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e70:	01 00 00 
  801e73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e77:	83 e0 01             	and    $0x1,%eax
  801e7a:	48 85 c0             	test   %rax,%rax
  801e7d:	75 12                	jne    801e91 <fd_alloc+0x7c>
			*fd_store = fd;
  801e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e87:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8f:	eb 1a                	jmp    801eab <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e91:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e95:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e99:	7e 8f                	jle    801e2a <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ea6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801eab:	c9                   	leaveq 
  801eac:	c3                   	retq   

0000000000801ead <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ead:	55                   	push   %rbp
  801eae:	48 89 e5             	mov    %rsp,%rbp
  801eb1:	48 83 ec 20          	sub    $0x20,%rsp
  801eb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ebc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ec0:	78 06                	js     801ec8 <fd_lookup+0x1b>
  801ec2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ec6:	7e 07                	jle    801ecf <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ecd:	eb 6c                	jmp    801f3b <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ecf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ed2:	48 98                	cltq   
  801ed4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eda:	48 c1 e0 0c          	shl    $0xc,%rax
  801ede:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee6:	48 c1 e8 15          	shr    $0x15,%rax
  801eea:	48 89 c2             	mov    %rax,%rdx
  801eed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ef4:	01 00 00 
  801ef7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efb:	83 e0 01             	and    $0x1,%eax
  801efe:	48 85 c0             	test   %rax,%rax
  801f01:	74 21                	je     801f24 <fd_lookup+0x77>
  801f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f07:	48 c1 e8 0c          	shr    $0xc,%rax
  801f0b:	48 89 c2             	mov    %rax,%rdx
  801f0e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f15:	01 00 00 
  801f18:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1c:	83 e0 01             	and    $0x1,%eax
  801f1f:	48 85 c0             	test   %rax,%rax
  801f22:	75 07                	jne    801f2b <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f29:	eb 10                	jmp    801f3b <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f2f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f33:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3b:	c9                   	leaveq 
  801f3c:	c3                   	retq   

0000000000801f3d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f3d:	55                   	push   %rbp
  801f3e:	48 89 e5             	mov    %rsp,%rbp
  801f41:	48 83 ec 30          	sub    $0x30,%rsp
  801f45:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f49:	89 f0                	mov    %esi,%eax
  801f4b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f52:	48 89 c7             	mov    %rax,%rdi
  801f55:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  801f5c:	00 00 00 
  801f5f:	ff d0                	callq  *%rax
  801f61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f65:	48 89 d6             	mov    %rdx,%rsi
  801f68:	89 c7                	mov    %eax,%edi
  801f6a:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  801f71:	00 00 00 
  801f74:	ff d0                	callq  *%rax
  801f76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7d:	78 0a                	js     801f89 <fd_close+0x4c>
	    || fd != fd2)
  801f7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f83:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f87:	74 12                	je     801f9b <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f89:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f8d:	74 05                	je     801f94 <fd_close+0x57>
  801f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f92:	eb 05                	jmp    801f99 <fd_close+0x5c>
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax
  801f99:	eb 69                	jmp    802004 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9f:	8b 00                	mov    (%rax),%eax
  801fa1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fa5:	48 89 d6             	mov    %rdx,%rsi
  801fa8:	89 c7                	mov    %eax,%edi
  801faa:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	callq  *%rax
  801fb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbd:	78 2a                	js     801fe9 <fd_close+0xac>
		if (dev->dev_close)
  801fbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fc7:	48 85 c0             	test   %rax,%rax
  801fca:	74 16                	je     801fe2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd0:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fd4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fd8:	48 89 d7             	mov    %rdx,%rdi
  801fdb:	ff d0                	callq  *%rax
  801fdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe0:	eb 07                	jmp    801fe9 <fd_close+0xac>
		else
			r = 0;
  801fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fe9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fed:	48 89 c6             	mov    %rax,%rsi
  801ff0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff5:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  801ffc:	00 00 00 
  801fff:	ff d0                	callq  *%rax
	return r;
  802001:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802004:	c9                   	leaveq 
  802005:	c3                   	retq   

0000000000802006 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802006:	55                   	push   %rbp
  802007:	48 89 e5             	mov    %rsp,%rbp
  80200a:	48 83 ec 20          	sub    $0x20,%rsp
  80200e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802011:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802015:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80201c:	eb 41                	jmp    80205f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80201e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802025:	00 00 00 
  802028:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202b:	48 63 d2             	movslq %edx,%rdx
  80202e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802032:	8b 00                	mov    (%rax),%eax
  802034:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802037:	75 22                	jne    80205b <dev_lookup+0x55>
			*dev = devtab[i];
  802039:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802040:	00 00 00 
  802043:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802046:	48 63 d2             	movslq %edx,%rdx
  802049:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80204d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802051:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
  802059:	eb 60                	jmp    8020bb <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80205b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802066:	00 00 00 
  802069:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80206c:	48 63 d2             	movslq %edx,%rdx
  80206f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802073:	48 85 c0             	test   %rax,%rax
  802076:	75 a6                	jne    80201e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802078:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80207f:	00 00 00 
  802082:	48 8b 00             	mov    (%rax),%rax
  802085:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80208b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80208e:	89 c6                	mov    %eax,%esi
  802090:	48 bf 58 4e 80 00 00 	movabs $0x804e58,%rdi
  802097:	00 00 00 
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	48 b9 03 05 80 00 00 	movabs $0x800503,%rcx
  8020a6:	00 00 00 
  8020a9:	ff d1                	callq  *%rcx
	*dev = 0;
  8020ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020af:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020bb:	c9                   	leaveq 
  8020bc:	c3                   	retq   

00000000008020bd <close>:

int
close(int fdnum)
{
  8020bd:	55                   	push   %rbp
  8020be:	48 89 e5             	mov    %rsp,%rbp
  8020c1:	48 83 ec 20          	sub    $0x20,%rsp
  8020c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020cf:	48 89 d6             	mov    %rdx,%rsi
  8020d2:	89 c7                	mov    %eax,%edi
  8020d4:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  8020db:	00 00 00 
  8020de:	ff d0                	callq  *%rax
  8020e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e7:	79 05                	jns    8020ee <close+0x31>
		return r;
  8020e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ec:	eb 18                	jmp    802106 <close+0x49>
	else
		return fd_close(fd, 1);
  8020ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f2:	be 01 00 00 00       	mov    $0x1,%esi
  8020f7:	48 89 c7             	mov    %rax,%rdi
  8020fa:	48 b8 3d 1f 80 00 00 	movabs $0x801f3d,%rax
  802101:	00 00 00 
  802104:	ff d0                	callq  *%rax
}
  802106:	c9                   	leaveq 
  802107:	c3                   	retq   

0000000000802108 <close_all>:

void
close_all(void)
{
  802108:	55                   	push   %rbp
  802109:	48 89 e5             	mov    %rsp,%rbp
  80210c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802117:	eb 15                	jmp    80212e <close_all+0x26>
		close(i);
  802119:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211c:	89 c7                	mov    %eax,%edi
  80211e:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802125:	00 00 00 
  802128:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80212a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80212e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802132:	7e e5                	jle    802119 <close_all+0x11>
		close(i);
}
  802134:	c9                   	leaveq 
  802135:	c3                   	retq   

0000000000802136 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802136:	55                   	push   %rbp
  802137:	48 89 e5             	mov    %rsp,%rbp
  80213a:	48 83 ec 40          	sub    $0x40,%rsp
  80213e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802141:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802144:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802148:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80214b:	48 89 d6             	mov    %rdx,%rsi
  80214e:	89 c7                	mov    %eax,%edi
  802150:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802157:	00 00 00 
  80215a:	ff d0                	callq  *%rax
  80215c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80215f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802163:	79 08                	jns    80216d <dup+0x37>
		return r;
  802165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802168:	e9 70 01 00 00       	jmpq   8022dd <dup+0x1a7>
	close(newfdnum);
  80216d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802170:	89 c7                	mov    %eax,%edi
  802172:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802179:	00 00 00 
  80217c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80217e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802181:	48 98                	cltq   
  802183:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802189:	48 c1 e0 0c          	shl    $0xc,%rax
  80218d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802191:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802195:	48 89 c7             	mov    %rax,%rdi
  802198:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  80219f:	00 00 00 
  8021a2:	ff d0                	callq  *%rax
  8021a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ac:	48 89 c7             	mov    %rax,%rdi
  8021af:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	callq  *%rax
  8021bb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c3:	48 c1 e8 15          	shr    $0x15,%rax
  8021c7:	48 89 c2             	mov    %rax,%rdx
  8021ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021d1:	01 00 00 
  8021d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d8:	83 e0 01             	and    $0x1,%eax
  8021db:	48 85 c0             	test   %rax,%rax
  8021de:	74 73                	je     802253 <dup+0x11d>
  8021e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e8:	48 89 c2             	mov    %rax,%rdx
  8021eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021f2:	01 00 00 
  8021f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f9:	83 e0 01             	and    $0x1,%eax
  8021fc:	48 85 c0             	test   %rax,%rax
  8021ff:	74 52                	je     802253 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802205:	48 c1 e8 0c          	shr    $0xc,%rax
  802209:	48 89 c2             	mov    %rax,%rdx
  80220c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802213:	01 00 00 
  802216:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221a:	25 07 0e 00 00       	and    $0xe07,%eax
  80221f:	89 c1                	mov    %eax,%ecx
  802221:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802225:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802229:	41 89 c8             	mov    %ecx,%r8d
  80222c:	48 89 d1             	mov    %rdx,%rcx
  80222f:	ba 00 00 00 00       	mov    $0x0,%edx
  802234:	48 89 c6             	mov    %rax,%rsi
  802237:	bf 00 00 00 00       	mov    $0x0,%edi
  80223c:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  802243:	00 00 00 
  802246:	ff d0                	callq  *%rax
  802248:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224f:	79 02                	jns    802253 <dup+0x11d>
			goto err;
  802251:	eb 57                	jmp    8022aa <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802257:	48 c1 e8 0c          	shr    $0xc,%rax
  80225b:	48 89 c2             	mov    %rax,%rdx
  80225e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802265:	01 00 00 
  802268:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226c:	25 07 0e 00 00       	and    $0xe07,%eax
  802271:	89 c1                	mov    %eax,%ecx
  802273:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802277:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227b:	41 89 c8             	mov    %ecx,%r8d
  80227e:	48 89 d1             	mov    %rdx,%rcx
  802281:	ba 00 00 00 00       	mov    $0x0,%edx
  802286:	48 89 c6             	mov    %rax,%rsi
  802289:	bf 00 00 00 00       	mov    $0x0,%edi
  80228e:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  802295:	00 00 00 
  802298:	ff d0                	callq  *%rax
  80229a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a1:	79 02                	jns    8022a5 <dup+0x16f>
		goto err;
  8022a3:	eb 05                	jmp    8022aa <dup+0x174>

	return newfdnum;
  8022a5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a8:	eb 33                	jmp    8022dd <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ae:	48 89 c6             	mov    %rax,%rsi
  8022b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b6:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c6:	48 89 c6             	mov    %rax,%rsi
  8022c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ce:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  8022d5:	00 00 00 
  8022d8:	ff d0                	callq  *%rax
	return r;
  8022da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022dd:	c9                   	leaveq 
  8022de:	c3                   	retq   

00000000008022df <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022df:	55                   	push   %rbp
  8022e0:	48 89 e5             	mov    %rsp,%rbp
  8022e3:	48 83 ec 40          	sub    $0x40,%rsp
  8022e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022ee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022f9:	48 89 d6             	mov    %rdx,%rsi
  8022fc:	89 c7                	mov    %eax,%edi
  8022fe:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
  80230a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802311:	78 24                	js     802337 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802317:	8b 00                	mov    (%rax),%eax
  802319:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231d:	48 89 d6             	mov    %rdx,%rsi
  802320:	89 c7                	mov    %eax,%edi
  802322:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax
  80232e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802331:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802335:	79 05                	jns    80233c <read+0x5d>
		return r;
  802337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233a:	eb 76                	jmp    8023b2 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80233c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802340:	8b 40 08             	mov    0x8(%rax),%eax
  802343:	83 e0 03             	and    $0x3,%eax
  802346:	83 f8 01             	cmp    $0x1,%eax
  802349:	75 3a                	jne    802385 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80234b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802352:	00 00 00 
  802355:	48 8b 00             	mov    (%rax),%rax
  802358:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80235e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802361:	89 c6                	mov    %eax,%esi
  802363:	48 bf 77 4e 80 00 00 	movabs $0x804e77,%rdi
  80236a:	00 00 00 
  80236d:	b8 00 00 00 00       	mov    $0x0,%eax
  802372:	48 b9 03 05 80 00 00 	movabs $0x800503,%rcx
  802379:	00 00 00 
  80237c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80237e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802383:	eb 2d                	jmp    8023b2 <read+0xd3>
	}
	if (!dev->dev_read)
  802385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802389:	48 8b 40 10          	mov    0x10(%rax),%rax
  80238d:	48 85 c0             	test   %rax,%rax
  802390:	75 07                	jne    802399 <read+0xba>
		return -E_NOT_SUPP;
  802392:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802397:	eb 19                	jmp    8023b2 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239d:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023a5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023a9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023ad:	48 89 cf             	mov    %rcx,%rdi
  8023b0:	ff d0                	callq  *%rax
}
  8023b2:	c9                   	leaveq 
  8023b3:	c3                   	retq   

00000000008023b4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023b4:	55                   	push   %rbp
  8023b5:	48 89 e5             	mov    %rsp,%rbp
  8023b8:	48 83 ec 30          	sub    $0x30,%rsp
  8023bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023ce:	eb 49                	jmp    802419 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d3:	48 98                	cltq   
  8023d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023d9:	48 29 c2             	sub    %rax,%rdx
  8023dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023df:	48 63 c8             	movslq %eax,%rcx
  8023e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e6:	48 01 c1             	add    %rax,%rcx
  8023e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ec:	48 89 ce             	mov    %rcx,%rsi
  8023ef:	89 c7                	mov    %eax,%edi
  8023f1:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
  8023fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802400:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802404:	79 05                	jns    80240b <readn+0x57>
			return m;
  802406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802409:	eb 1c                	jmp    802427 <readn+0x73>
		if (m == 0)
  80240b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80240f:	75 02                	jne    802413 <readn+0x5f>
			break;
  802411:	eb 11                	jmp    802424 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802413:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802416:	01 45 fc             	add    %eax,-0x4(%rbp)
  802419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241c:	48 98                	cltq   
  80241e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802422:	72 ac                	jb     8023d0 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802424:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802427:	c9                   	leaveq 
  802428:	c3                   	retq   

0000000000802429 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802429:	55                   	push   %rbp
  80242a:	48 89 e5             	mov    %rsp,%rbp
  80242d:	48 83 ec 40          	sub    $0x40,%rsp
  802431:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802434:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802438:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80243c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802440:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802443:	48 89 d6             	mov    %rdx,%rsi
  802446:	89 c7                	mov    %eax,%edi
  802448:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  80244f:	00 00 00 
  802452:	ff d0                	callq  *%rax
  802454:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802457:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245b:	78 24                	js     802481 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80245d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802461:	8b 00                	mov    (%rax),%eax
  802463:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802467:	48 89 d6             	mov    %rdx,%rsi
  80246a:	89 c7                	mov    %eax,%edi
  80246c:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  802473:	00 00 00 
  802476:	ff d0                	callq  *%rax
  802478:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247f:	79 05                	jns    802486 <write+0x5d>
		return r;
  802481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802484:	eb 75                	jmp    8024fb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248a:	8b 40 08             	mov    0x8(%rax),%eax
  80248d:	83 e0 03             	and    $0x3,%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	75 3a                	jne    8024ce <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802494:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80249b:	00 00 00 
  80249e:	48 8b 00             	mov    (%rax),%rax
  8024a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024aa:	89 c6                	mov    %eax,%esi
  8024ac:	48 bf 93 4e 80 00 00 	movabs $0x804e93,%rdi
  8024b3:	00 00 00 
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	48 b9 03 05 80 00 00 	movabs $0x800503,%rcx
  8024c2:	00 00 00 
  8024c5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024cc:	eb 2d                	jmp    8024fb <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d6:	48 85 c0             	test   %rax,%rax
  8024d9:	75 07                	jne    8024e2 <write+0xb9>
		return -E_NOT_SUPP;
  8024db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e0:	eb 19                	jmp    8024fb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024f2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024f6:	48 89 cf             	mov    %rcx,%rdi
  8024f9:	ff d0                	callq  *%rax
}
  8024fb:	c9                   	leaveq 
  8024fc:	c3                   	retq   

00000000008024fd <seek>:

int
seek(int fdnum, off_t offset)
{
  8024fd:	55                   	push   %rbp
  8024fe:	48 89 e5             	mov    %rsp,%rbp
  802501:	48 83 ec 18          	sub    $0x18,%rsp
  802505:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802508:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80250b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80250f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802512:	48 89 d6             	mov    %rdx,%rsi
  802515:	89 c7                	mov    %eax,%edi
  802517:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  80251e:	00 00 00 
  802521:	ff d0                	callq  *%rax
  802523:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802526:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252a:	79 05                	jns    802531 <seek+0x34>
		return r;
  80252c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252f:	eb 0f                	jmp    802540 <seek+0x43>
	fd->fd_offset = offset;
  802531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802535:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802538:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802540:	c9                   	leaveq 
  802541:	c3                   	retq   

0000000000802542 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802542:	55                   	push   %rbp
  802543:	48 89 e5             	mov    %rsp,%rbp
  802546:	48 83 ec 30          	sub    $0x30,%rsp
  80254a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80254d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802550:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802554:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802557:	48 89 d6             	mov    %rdx,%rsi
  80255a:	89 c7                	mov    %eax,%edi
  80255c:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802563:	00 00 00 
  802566:	ff d0                	callq  *%rax
  802568:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256f:	78 24                	js     802595 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802575:	8b 00                	mov    (%rax),%eax
  802577:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80257b:	48 89 d6             	mov    %rdx,%rsi
  80257e:	89 c7                	mov    %eax,%edi
  802580:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  802587:	00 00 00 
  80258a:	ff d0                	callq  *%rax
  80258c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802593:	79 05                	jns    80259a <ftruncate+0x58>
		return r;
  802595:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802598:	eb 72                	jmp    80260c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80259a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259e:	8b 40 08             	mov    0x8(%rax),%eax
  8025a1:	83 e0 03             	and    $0x3,%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	75 3a                	jne    8025e2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025a8:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8025af:	00 00 00 
  8025b2:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025b5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025be:	89 c6                	mov    %eax,%esi
  8025c0:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  8025c7:	00 00 00 
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	48 b9 03 05 80 00 00 	movabs $0x800503,%rcx
  8025d6:	00 00 00 
  8025d9:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025e0:	eb 2a                	jmp    80260c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025ea:	48 85 c0             	test   %rax,%rax
  8025ed:	75 07                	jne    8025f6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f4:	eb 16                	jmp    80260c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fa:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802602:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802605:	89 ce                	mov    %ecx,%esi
  802607:	48 89 d7             	mov    %rdx,%rdi
  80260a:	ff d0                	callq  *%rax
}
  80260c:	c9                   	leaveq 
  80260d:	c3                   	retq   

000000000080260e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80260e:	55                   	push   %rbp
  80260f:	48 89 e5             	mov    %rsp,%rbp
  802612:	48 83 ec 30          	sub    $0x30,%rsp
  802616:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802619:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80261d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802621:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802624:	48 89 d6             	mov    %rdx,%rsi
  802627:	89 c7                	mov    %eax,%edi
  802629:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802630:	00 00 00 
  802633:	ff d0                	callq  *%rax
  802635:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802638:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263c:	78 24                	js     802662 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802642:	8b 00                	mov    (%rax),%eax
  802644:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802648:	48 89 d6             	mov    %rdx,%rsi
  80264b:	89 c7                	mov    %eax,%edi
  80264d:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  802654:	00 00 00 
  802657:	ff d0                	callq  *%rax
  802659:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802660:	79 05                	jns    802667 <fstat+0x59>
		return r;
  802662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802665:	eb 5e                	jmp    8026c5 <fstat+0xb7>
	if (!dev->dev_stat)
  802667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80266f:	48 85 c0             	test   %rax,%rax
  802672:	75 07                	jne    80267b <fstat+0x6d>
		return -E_NOT_SUPP;
  802674:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802679:	eb 4a                	jmp    8026c5 <fstat+0xb7>
	stat->st_name[0] = 0;
  80267b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802682:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802686:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80268d:	00 00 00 
	stat->st_isdir = 0;
  802690:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802694:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80269b:	00 00 00 
	stat->st_dev = dev;
  80269e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a6:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026bd:	48 89 ce             	mov    %rcx,%rsi
  8026c0:	48 89 d7             	mov    %rdx,%rdi
  8026c3:	ff d0                	callq  *%rax
}
  8026c5:	c9                   	leaveq 
  8026c6:	c3                   	retq   

00000000008026c7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026c7:	55                   	push   %rbp
  8026c8:	48 89 e5             	mov    %rsp,%rbp
  8026cb:	48 83 ec 20          	sub    $0x20,%rsp
  8026cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026db:	be 00 00 00 00       	mov    $0x0,%esi
  8026e0:	48 89 c7             	mov    %rax,%rdi
  8026e3:	48 b8 b5 27 80 00 00 	movabs $0x8027b5,%rax
  8026ea:	00 00 00 
  8026ed:	ff d0                	callq  *%rax
  8026ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f6:	79 05                	jns    8026fd <stat+0x36>
		return fd;
  8026f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fb:	eb 2f                	jmp    80272c <stat+0x65>
	r = fstat(fd, stat);
  8026fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802704:	48 89 d6             	mov    %rdx,%rsi
  802707:	89 c7                	mov    %eax,%edi
  802709:	48 b8 0e 26 80 00 00 	movabs $0x80260e,%rax
  802710:	00 00 00 
  802713:	ff d0                	callq  *%rax
  802715:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802718:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271b:	89 c7                	mov    %eax,%edi
  80271d:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802724:	00 00 00 
  802727:	ff d0                	callq  *%rax
	return r;
  802729:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80272c:	c9                   	leaveq 
  80272d:	c3                   	retq   

000000000080272e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80272e:	55                   	push   %rbp
  80272f:	48 89 e5             	mov    %rsp,%rbp
  802732:	48 83 ec 10          	sub    $0x10,%rsp
  802736:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802739:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80273d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802744:	00 00 00 
  802747:	8b 00                	mov    (%rax),%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	75 1d                	jne    80276a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80274d:	bf 01 00 00 00       	mov    $0x1,%edi
  802752:	48 b8 5b 42 80 00 00 	movabs $0x80425b,%rax
  802759:	00 00 00 
  80275c:	ff d0                	callq  *%rax
  80275e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802765:	00 00 00 
  802768:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80276a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802771:	00 00 00 
  802774:	8b 00                	mov    (%rax),%eax
  802776:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802779:	b9 07 00 00 00       	mov    $0x7,%ecx
  80277e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802785:	00 00 00 
  802788:	89 c7                	mov    %eax,%edi
  80278a:	48 b8 4f 40 80 00 00 	movabs $0x80404f,%rax
  802791:	00 00 00 
  802794:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279a:	ba 00 00 00 00       	mov    $0x0,%edx
  80279f:	48 89 c6             	mov    %rax,%rsi
  8027a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a7:	48 b8 8e 3f 80 00 00 	movabs $0x803f8e,%rax
  8027ae:	00 00 00 
  8027b1:	ff d0                	callq  *%rax
}
  8027b3:	c9                   	leaveq 
  8027b4:	c3                   	retq   

00000000008027b5 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027b5:	55                   	push   %rbp
  8027b6:	48 89 e5             	mov    %rsp,%rbp
  8027b9:	48 83 ec 20          	sub    $0x20,%rsp
  8027bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027c1:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8027c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c8:	48 89 c7             	mov    %rax,%rdi
  8027cb:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8027d2:	00 00 00 
  8027d5:	ff d0                	callq  *%rax
  8027d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027dc:	7e 0a                	jle    8027e8 <open+0x33>
		return -E_BAD_PATH;
  8027de:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027e3:	e9 a5 00 00 00       	jmpq   80288d <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8027e8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027ec:	48 89 c7             	mov    %rax,%rdi
  8027ef:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
  8027fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802802:	79 08                	jns    80280c <open+0x57>
		return r;
  802804:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802807:	e9 81 00 00 00       	jmpq   80288d <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80280c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802810:	48 89 c6             	mov    %rax,%rsi
  802813:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80281a:	00 00 00 
  80281d:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802824:	00 00 00 
  802827:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802829:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802830:	00 00 00 
  802833:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802836:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80283c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802840:	48 89 c6             	mov    %rax,%rsi
  802843:	bf 01 00 00 00       	mov    $0x1,%edi
  802848:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
  802854:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802857:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285b:	79 1d                	jns    80287a <open+0xc5>
		fd_close(fd, 0);
  80285d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802861:	be 00 00 00 00       	mov    $0x0,%esi
  802866:	48 89 c7             	mov    %rax,%rdi
  802869:	48 b8 3d 1f 80 00 00 	movabs $0x801f3d,%rax
  802870:	00 00 00 
  802873:	ff d0                	callq  *%rax
		return r;
  802875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802878:	eb 13                	jmp    80288d <open+0xd8>
	}

	return fd2num(fd);
  80287a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287e:	48 89 c7             	mov    %rax,%rdi
  802881:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  802888:	00 00 00 
  80288b:	ff d0                	callq  *%rax

}
  80288d:	c9                   	leaveq 
  80288e:	c3                   	retq   

000000000080288f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80288f:	55                   	push   %rbp
  802890:	48 89 e5             	mov    %rsp,%rbp
  802893:	48 83 ec 10          	sub    $0x10,%rsp
  802897:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80289b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80289f:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028a9:	00 00 00 
  8028ac:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028ae:	be 00 00 00 00       	mov    $0x0,%esi
  8028b3:	bf 06 00 00 00       	mov    $0x6,%edi
  8028b8:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
}
  8028c4:	c9                   	leaveq 
  8028c5:	c3                   	retq   

00000000008028c6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028c6:	55                   	push   %rbp
  8028c7:	48 89 e5             	mov    %rsp,%rbp
  8028ca:	48 83 ec 30          	sub    $0x30,%rsp
  8028ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028de:	8b 50 0c             	mov    0xc(%rax),%edx
  8028e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028e8:	00 00 00 
  8028eb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028ed:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028f4:	00 00 00 
  8028f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028fb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028ff:	be 00 00 00 00       	mov    $0x0,%esi
  802904:	bf 03 00 00 00       	mov    $0x3,%edi
  802909:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
  802915:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802918:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291c:	79 08                	jns    802926 <devfile_read+0x60>
		return r;
  80291e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802921:	e9 a4 00 00 00       	jmpq   8029ca <devfile_read+0x104>
	assert(r <= n);
  802926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802929:	48 98                	cltq   
  80292b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80292f:	76 35                	jbe    802966 <devfile_read+0xa0>
  802931:	48 b9 d6 4e 80 00 00 	movabs $0x804ed6,%rcx
  802938:	00 00 00 
  80293b:	48 ba dd 4e 80 00 00 	movabs $0x804edd,%rdx
  802942:	00 00 00 
  802945:	be 86 00 00 00       	mov    $0x86,%esi
  80294a:	48 bf f2 4e 80 00 00 	movabs $0x804ef2,%rdi
  802951:	00 00 00 
  802954:	b8 00 00 00 00       	mov    $0x0,%eax
  802959:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  802960:	00 00 00 
  802963:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802966:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80296d:	7e 35                	jle    8029a4 <devfile_read+0xde>
  80296f:	48 b9 fd 4e 80 00 00 	movabs $0x804efd,%rcx
  802976:	00 00 00 
  802979:	48 ba dd 4e 80 00 00 	movabs $0x804edd,%rdx
  802980:	00 00 00 
  802983:	be 87 00 00 00       	mov    $0x87,%esi
  802988:	48 bf f2 4e 80 00 00 	movabs $0x804ef2,%rdi
  80298f:	00 00 00 
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  80299e:	00 00 00 
  8029a1:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8029a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a7:	48 63 d0             	movslq %eax,%rdx
  8029aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ae:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029b5:	00 00 00 
  8029b8:	48 89 c7             	mov    %rax,%rdi
  8029bb:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8029c2:	00 00 00 
  8029c5:	ff d0                	callq  *%rax
	return r;
  8029c7:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8029ca:	c9                   	leaveq 
  8029cb:	c3                   	retq   

00000000008029cc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029cc:	55                   	push   %rbp
  8029cd:	48 89 e5             	mov    %rsp,%rbp
  8029d0:	48 83 ec 40          	sub    $0x40,%rsp
  8029d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029dc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8029e0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8029e8:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8029ef:	00 
  8029f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8029f8:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8029fd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a05:	8b 50 0c             	mov    0xc(%rax),%edx
  802a08:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a0f:	00 00 00 
  802a12:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a14:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a1b:	00 00 00 
  802a1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a22:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802a26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a2e:	48 89 c6             	mov    %rax,%rsi
  802a31:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802a38:	00 00 00 
  802a3b:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a47:	be 00 00 00 00       	mov    $0x0,%esi
  802a4c:	bf 04 00 00 00       	mov    $0x4,%edi
  802a51:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  802a58:	00 00 00 
  802a5b:	ff d0                	callq  *%rax
  802a5d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a60:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a64:	79 05                	jns    802a6b <devfile_write+0x9f>
		return r;
  802a66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a69:	eb 43                	jmp    802aae <devfile_write+0xe2>
	assert(r <= n);
  802a6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a6e:	48 98                	cltq   
  802a70:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802a74:	76 35                	jbe    802aab <devfile_write+0xdf>
  802a76:	48 b9 d6 4e 80 00 00 	movabs $0x804ed6,%rcx
  802a7d:	00 00 00 
  802a80:	48 ba dd 4e 80 00 00 	movabs $0x804edd,%rdx
  802a87:	00 00 00 
  802a8a:	be a2 00 00 00       	mov    $0xa2,%esi
  802a8f:	48 bf f2 4e 80 00 00 	movabs $0x804ef2,%rdi
  802a96:	00 00 00 
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9e:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  802aa5:	00 00 00 
  802aa8:	41 ff d0             	callq  *%r8
	return r;
  802aab:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802aae:	c9                   	leaveq 
  802aaf:	c3                   	retq   

0000000000802ab0 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ab0:	55                   	push   %rbp
  802ab1:	48 89 e5             	mov    %rsp,%rbp
  802ab4:	48 83 ec 20          	sub    $0x20,%rsp
  802ab8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802abc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac4:	8b 50 0c             	mov    0xc(%rax),%edx
  802ac7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ace:	00 00 00 
  802ad1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ad3:	be 00 00 00 00       	mov    $0x0,%esi
  802ad8:	bf 05 00 00 00       	mov    $0x5,%edi
  802add:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
  802ae9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af0:	79 05                	jns    802af7 <devfile_stat+0x47>
		return r;
  802af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af5:	eb 56                	jmp    802b4d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802af7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802afb:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802b02:	00 00 00 
  802b05:	48 89 c7             	mov    %rax,%rdi
  802b08:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802b0f:	00 00 00 
  802b12:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b14:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b1b:	00 00 00 
  802b1e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b28:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b2e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b35:	00 00 00 
  802b38:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b42:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b4d:	c9                   	leaveq 
  802b4e:	c3                   	retq   

0000000000802b4f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b4f:	55                   	push   %rbp
  802b50:	48 89 e5             	mov    %rsp,%rbp
  802b53:	48 83 ec 10          	sub    $0x10,%rsp
  802b57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b5b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b62:	8b 50 0c             	mov    0xc(%rax),%edx
  802b65:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b6c:	00 00 00 
  802b6f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b71:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b78:	00 00 00 
  802b7b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b81:	be 00 00 00 00       	mov    $0x0,%esi
  802b86:	bf 02 00 00 00       	mov    $0x2,%edi
  802b8b:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  802b92:	00 00 00 
  802b95:	ff d0                	callq  *%rax
}
  802b97:	c9                   	leaveq 
  802b98:	c3                   	retq   

0000000000802b99 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b99:	55                   	push   %rbp
  802b9a:	48 89 e5             	mov    %rsp,%rbp
  802b9d:	48 83 ec 10          	sub    $0x10,%rsp
  802ba1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ba5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ba9:	48 89 c7             	mov    %rax,%rdi
  802bac:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  802bb3:	00 00 00 
  802bb6:	ff d0                	callq  *%rax
  802bb8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bbd:	7e 07                	jle    802bc6 <remove+0x2d>
		return -E_BAD_PATH;
  802bbf:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bc4:	eb 33                	jmp    802bf9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bca:	48 89 c6             	mov    %rax,%rsi
  802bcd:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802bd4:	00 00 00 
  802bd7:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802be3:	be 00 00 00 00       	mov    $0x0,%esi
  802be8:	bf 07 00 00 00       	mov    $0x7,%edi
  802bed:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
}
  802bf9:	c9                   	leaveq 
  802bfa:	c3                   	retq   

0000000000802bfb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bfb:	55                   	push   %rbp
  802bfc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bff:	be 00 00 00 00       	mov    $0x0,%esi
  802c04:	bf 08 00 00 00       	mov    $0x8,%edi
  802c09:	48 b8 2e 27 80 00 00 	movabs $0x80272e,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
}
  802c15:	5d                   	pop    %rbp
  802c16:	c3                   	retq   

0000000000802c17 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c17:	55                   	push   %rbp
  802c18:	48 89 e5             	mov    %rsp,%rbp
  802c1b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c22:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c29:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c30:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c37:	be 00 00 00 00       	mov    $0x0,%esi
  802c3c:	48 89 c7             	mov    %rax,%rdi
  802c3f:	48 b8 b5 27 80 00 00 	movabs $0x8027b5,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
  802c4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c52:	79 28                	jns    802c7c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c57:	89 c6                	mov    %eax,%esi
  802c59:	48 bf 09 4f 80 00 00 	movabs $0x804f09,%rdi
  802c60:	00 00 00 
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
  802c68:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  802c6f:	00 00 00 
  802c72:	ff d2                	callq  *%rdx
		return fd_src;
  802c74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c77:	e9 74 01 00 00       	jmpq   802df0 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c7c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c83:	be 01 01 00 00       	mov    $0x101,%esi
  802c88:	48 89 c7             	mov    %rax,%rdi
  802c8b:	48 b8 b5 27 80 00 00 	movabs $0x8027b5,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
  802c97:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c9a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c9e:	79 39                	jns    802cd9 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ca0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca3:	89 c6                	mov    %eax,%esi
  802ca5:	48 bf 1f 4f 80 00 00 	movabs $0x804f1f,%rdi
  802cac:	00 00 00 
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  802cbb:	00 00 00 
  802cbe:	ff d2                	callq  *%rdx
		close(fd_src);
  802cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc3:	89 c7                	mov    %eax,%edi
  802cc5:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	callq  *%rax
		return fd_dest;
  802cd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd4:	e9 17 01 00 00       	jmpq   802df0 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cd9:	eb 74                	jmp    802d4f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802cdb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cde:	48 63 d0             	movslq %eax,%rdx
  802ce1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ce8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ceb:	48 89 ce             	mov    %rcx,%rsi
  802cee:	89 c7                	mov    %eax,%edi
  802cf0:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	callq  *%rax
  802cfc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802cff:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d03:	79 4a                	jns    802d4f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d05:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d08:	89 c6                	mov    %eax,%esi
  802d0a:	48 bf 39 4f 80 00 00 	movabs $0x804f39,%rdi
  802d11:	00 00 00 
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
  802d19:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  802d20:	00 00 00 
  802d23:	ff d2                	callq  *%rdx
			close(fd_src);
  802d25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d28:	89 c7                	mov    %eax,%edi
  802d2a:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
			close(fd_dest);
  802d36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d39:	89 c7                	mov    %eax,%edi
  802d3b:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802d42:	00 00 00 
  802d45:	ff d0                	callq  *%rax
			return write_size;
  802d47:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d4a:	e9 a1 00 00 00       	jmpq   802df0 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d4f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d59:	ba 00 02 00 00       	mov    $0x200,%edx
  802d5e:	48 89 ce             	mov    %rcx,%rsi
  802d61:	89 c7                	mov    %eax,%edi
  802d63:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d72:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d76:	0f 8f 5f ff ff ff    	jg     802cdb <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d80:	79 47                	jns    802dc9 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d82:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d85:	89 c6                	mov    %eax,%esi
  802d87:	48 bf 4c 4f 80 00 00 	movabs $0x804f4c,%rdi
  802d8e:	00 00 00 
  802d91:	b8 00 00 00 00       	mov    $0x0,%eax
  802d96:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  802d9d:	00 00 00 
  802da0:	ff d2                	callq  *%rdx
		close(fd_src);
  802da2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da5:	89 c7                	mov    %eax,%edi
  802da7:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802dae:	00 00 00 
  802db1:	ff d0                	callq  *%rax
		close(fd_dest);
  802db3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802db6:	89 c7                	mov    %eax,%edi
  802db8:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802dbf:	00 00 00 
  802dc2:	ff d0                	callq  *%rax
		return read_size;
  802dc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dc7:	eb 27                	jmp    802df0 <copy+0x1d9>
	}
	close(fd_src);
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	89 c7                	mov    %eax,%edi
  802dce:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802dd5:	00 00 00 
  802dd8:	ff d0                	callq  *%rax
	close(fd_dest);
  802dda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddd:	89 c7                	mov    %eax,%edi
  802ddf:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  802de6:	00 00 00 
  802de9:	ff d0                	callq  *%rax
	return 0;
  802deb:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 20          	sub    $0x20,%rsp
  802dfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802dfd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e04:	48 89 d6             	mov    %rdx,%rsi
  802e07:	89 c7                	mov    %eax,%edi
  802e09:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
  802e15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1c:	79 05                	jns    802e23 <fd2sockid+0x31>
		return r;
  802e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e21:	eb 24                	jmp    802e47 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e27:	8b 10                	mov    (%rax),%edx
  802e29:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  802e30:	00 00 00 
  802e33:	8b 00                	mov    (%rax),%eax
  802e35:	39 c2                	cmp    %eax,%edx
  802e37:	74 07                	je     802e40 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e39:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e3e:	eb 07                	jmp    802e47 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e44:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e47:	c9                   	leaveq 
  802e48:	c3                   	retq   

0000000000802e49 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e49:	55                   	push   %rbp
  802e4a:	48 89 e5             	mov    %rsp,%rbp
  802e4d:	48 83 ec 20          	sub    $0x20,%rsp
  802e51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e54:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e58:	48 89 c7             	mov    %rax,%rdi
  802e5b:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
  802e67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6e:	78 26                	js     802e96 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e74:	ba 07 04 00 00       	mov    $0x407,%edx
  802e79:	48 89 c6             	mov    %rax,%rsi
  802e7c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e81:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
  802e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e94:	79 16                	jns    802eac <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e99:	89 c7                	mov    %eax,%edi
  802e9b:	48 b8 56 33 80 00 00 	movabs $0x803356,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
		return r;
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaa:	eb 3a                	jmp    802ee6 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb0:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  802eb7:	00 00 00 
  802eba:	8b 12                	mov    (%rdx),%edx
  802ebc:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802ec9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ed0:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed7:	48 89 c7             	mov    %rax,%rdi
  802eda:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
}
  802ee6:	c9                   	leaveq 
  802ee7:	c3                   	retq   

0000000000802ee8 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ee8:	55                   	push   %rbp
  802ee9:	48 89 e5             	mov    %rsp,%rbp
  802eec:	48 83 ec 30          	sub    $0x30,%rsp
  802ef0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ef3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ef7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802efb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802efe:	89 c7                	mov    %eax,%edi
  802f00:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
  802f0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f13:	79 05                	jns    802f1a <accept+0x32>
		return r;
  802f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f18:	eb 3b                	jmp    802f55 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f1a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f1e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f25:	48 89 ce             	mov    %rcx,%rsi
  802f28:	89 c7                	mov    %eax,%edi
  802f2a:	48 b8 33 32 80 00 00 	movabs $0x803233,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
  802f36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3d:	79 05                	jns    802f44 <accept+0x5c>
		return r;
  802f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f42:	eb 11                	jmp    802f55 <accept+0x6d>
	return alloc_sockfd(r);
  802f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f47:	89 c7                	mov    %eax,%edi
  802f49:	48 b8 49 2e 80 00 00 	movabs $0x802e49,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
}
  802f55:	c9                   	leaveq 
  802f56:	c3                   	retq   

0000000000802f57 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f57:	55                   	push   %rbp
  802f58:	48 89 e5             	mov    %rsp,%rbp
  802f5b:	48 83 ec 20          	sub    $0x20,%rsp
  802f5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f66:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f6c:	89 c7                	mov    %eax,%edi
  802f6e:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  802f75:	00 00 00 
  802f78:	ff d0                	callq  *%rax
  802f7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f81:	79 05                	jns    802f88 <bind+0x31>
		return r;
  802f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f86:	eb 1b                	jmp    802fa3 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f88:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f8b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f92:	48 89 ce             	mov    %rcx,%rsi
  802f95:	89 c7                	mov    %eax,%edi
  802f97:	48 b8 b2 32 80 00 00 	movabs $0x8032b2,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
}
  802fa3:	c9                   	leaveq 
  802fa4:	c3                   	retq   

0000000000802fa5 <shutdown>:

int
shutdown(int s, int how)
{
  802fa5:	55                   	push   %rbp
  802fa6:	48 89 e5             	mov    %rsp,%rbp
  802fa9:	48 83 ec 20          	sub    $0x20,%rsp
  802fad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fb0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fb6:	89 c7                	mov    %eax,%edi
  802fb8:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
  802fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcb:	79 05                	jns    802fd2 <shutdown+0x2d>
		return r;
  802fcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd0:	eb 16                	jmp    802fe8 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802fd2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd8:	89 d6                	mov    %edx,%esi
  802fda:	89 c7                	mov    %eax,%edi
  802fdc:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  802fe3:	00 00 00 
  802fe6:	ff d0                	callq  *%rax
}
  802fe8:	c9                   	leaveq 
  802fe9:	c3                   	retq   

0000000000802fea <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802fea:	55                   	push   %rbp
  802feb:	48 89 e5             	mov    %rsp,%rbp
  802fee:	48 83 ec 10          	sub    $0x10,%rsp
  802ff2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffa:	48 89 c7             	mov    %rax,%rdi
  802ffd:	48 b8 cd 42 80 00 00 	movabs $0x8042cd,%rax
  803004:	00 00 00 
  803007:	ff d0                	callq  *%rax
  803009:	83 f8 01             	cmp    $0x1,%eax
  80300c:	75 17                	jne    803025 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80300e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803012:	8b 40 0c             	mov    0xc(%rax),%eax
  803015:	89 c7                	mov    %eax,%edi
  803017:	48 b8 56 33 80 00 00 	movabs $0x803356,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
  803023:	eb 05                	jmp    80302a <devsock_close+0x40>
	else
		return 0;
  803025:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80302a:	c9                   	leaveq 
  80302b:	c3                   	retq   

000000000080302c <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80302c:	55                   	push   %rbp
  80302d:	48 89 e5             	mov    %rsp,%rbp
  803030:	48 83 ec 20          	sub    $0x20,%rsp
  803034:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803037:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80303b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80303e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803041:	89 c7                	mov    %eax,%edi
  803043:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
  80304f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803052:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803056:	79 05                	jns    80305d <connect+0x31>
		return r;
  803058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305b:	eb 1b                	jmp    803078 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80305d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803060:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803067:	48 89 ce             	mov    %rcx,%rsi
  80306a:	89 c7                	mov    %eax,%edi
  80306c:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
}
  803078:	c9                   	leaveq 
  803079:	c3                   	retq   

000000000080307a <listen>:

int
listen(int s, int backlog)
{
  80307a:	55                   	push   %rbp
  80307b:	48 89 e5             	mov    %rsp,%rbp
  80307e:	48 83 ec 20          	sub    $0x20,%rsp
  803082:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803085:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803088:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80308b:	89 c7                	mov    %eax,%edi
  80308d:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  803094:	00 00 00 
  803097:	ff d0                	callq  *%rax
  803099:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a0:	79 05                	jns    8030a7 <listen+0x2d>
		return r;
  8030a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a5:	eb 16                	jmp    8030bd <listen+0x43>
	return nsipc_listen(r, backlog);
  8030a7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ad:	89 d6                	mov    %edx,%esi
  8030af:	89 c7                	mov    %eax,%edi
  8030b1:	48 b8 e7 33 80 00 00 	movabs $0x8033e7,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	callq  *%rax
}
  8030bd:	c9                   	leaveq 
  8030be:	c3                   	retq   

00000000008030bf <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030bf:	55                   	push   %rbp
  8030c0:	48 89 e5             	mov    %rsp,%rbp
  8030c3:	48 83 ec 20          	sub    $0x20,%rsp
  8030c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d7:	89 c2                	mov    %eax,%edx
  8030d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030dd:	8b 40 0c             	mov    0xc(%rax),%eax
  8030e0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030e9:	89 c7                	mov    %eax,%edi
  8030eb:	48 b8 27 34 80 00 00 	movabs $0x803427,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
}
  8030f7:	c9                   	leaveq 
  8030f8:	c3                   	retq   

00000000008030f9 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8030f9:	55                   	push   %rbp
  8030fa:	48 89 e5             	mov    %rsp,%rbp
  8030fd:	48 83 ec 20          	sub    $0x20,%rsp
  803101:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803105:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803109:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80310d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803111:	89 c2                	mov    %eax,%edx
  803113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803117:	8b 40 0c             	mov    0xc(%rax),%eax
  80311a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80311e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803123:	89 c7                	mov    %eax,%edi
  803125:	48 b8 f3 34 80 00 00 	movabs $0x8034f3,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
}
  803131:	c9                   	leaveq 
  803132:	c3                   	retq   

0000000000803133 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803133:	55                   	push   %rbp
  803134:	48 89 e5             	mov    %rsp,%rbp
  803137:	48 83 ec 10          	sub    $0x10,%rsp
  80313b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80313f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803143:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803147:	48 be 67 4f 80 00 00 	movabs $0x804f67,%rsi
  80314e:	00 00 00 
  803151:	48 89 c7             	mov    %rax,%rdi
  803154:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
	return 0;
  803160:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803165:	c9                   	leaveq 
  803166:	c3                   	retq   

0000000000803167 <socket>:

int
socket(int domain, int type, int protocol)
{
  803167:	55                   	push   %rbp
  803168:	48 89 e5             	mov    %rsp,%rbp
  80316b:	48 83 ec 20          	sub    $0x20,%rsp
  80316f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803172:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803175:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803178:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80317b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80317e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803181:	89 ce                	mov    %ecx,%esi
  803183:	89 c7                	mov    %eax,%edi
  803185:	48 b8 ab 35 80 00 00 	movabs $0x8035ab,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803198:	79 05                	jns    80319f <socket+0x38>
		return r;
  80319a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319d:	eb 11                	jmp    8031b0 <socket+0x49>
	return alloc_sockfd(r);
  80319f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a2:	89 c7                	mov    %eax,%edi
  8031a4:	48 b8 49 2e 80 00 00 	movabs $0x802e49,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
}
  8031b0:	c9                   	leaveq 
  8031b1:	c3                   	retq   

00000000008031b2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8031b2:	55                   	push   %rbp
  8031b3:	48 89 e5             	mov    %rsp,%rbp
  8031b6:	48 83 ec 10          	sub    $0x10,%rsp
  8031ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8031bd:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8031c4:	00 00 00 
  8031c7:	8b 00                	mov    (%rax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	75 1d                	jne    8031ea <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031cd:	bf 02 00 00 00       	mov    $0x2,%edi
  8031d2:	48 b8 5b 42 80 00 00 	movabs $0x80425b,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8031e5:	00 00 00 
  8031e8:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8031ea:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8031f1:	00 00 00 
  8031f4:	8b 00                	mov    (%rax),%eax
  8031f6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031f9:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031fe:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803205:	00 00 00 
  803208:	89 c7                	mov    %eax,%edi
  80320a:	48 b8 4f 40 80 00 00 	movabs $0x80404f,%rax
  803211:	00 00 00 
  803214:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803216:	ba 00 00 00 00       	mov    $0x0,%edx
  80321b:	be 00 00 00 00       	mov    $0x0,%esi
  803220:	bf 00 00 00 00       	mov    $0x0,%edi
  803225:	48 b8 8e 3f 80 00 00 	movabs $0x803f8e,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
}
  803231:	c9                   	leaveq 
  803232:	c3                   	retq   

0000000000803233 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803233:	55                   	push   %rbp
  803234:	48 89 e5             	mov    %rsp,%rbp
  803237:	48 83 ec 30          	sub    $0x30,%rsp
  80323b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80323e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803242:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803246:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80324d:	00 00 00 
  803250:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803253:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803255:	bf 01 00 00 00       	mov    $0x1,%edi
  80325a:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
  803266:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803269:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326d:	78 3e                	js     8032ad <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80326f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803276:	00 00 00 
  803279:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80327d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803281:	8b 40 10             	mov    0x10(%rax),%eax
  803284:	89 c2                	mov    %eax,%edx
  803286:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80328a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80328e:	48 89 ce             	mov    %rcx,%rsi
  803291:	48 89 c7             	mov    %rax,%rdi
  803294:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  80329b:	00 00 00 
  80329e:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8032a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a4:	8b 50 10             	mov    0x10(%rax),%edx
  8032a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ab:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8032ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032b0:	c9                   	leaveq 
  8032b1:	c3                   	retq   

00000000008032b2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032b2:	55                   	push   %rbp
  8032b3:	48 89 e5             	mov    %rsp,%rbp
  8032b6:	48 83 ec 10          	sub    $0x10,%rsp
  8032ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032c1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8032c4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8032cb:	00 00 00 
  8032ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032d3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032da:	48 89 c6             	mov    %rax,%rsi
  8032dd:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8032e4:	00 00 00 
  8032e7:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8032ee:	00 00 00 
  8032f1:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8032f3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8032fa:	00 00 00 
  8032fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803300:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803303:	bf 02 00 00 00       	mov    $0x2,%edi
  803308:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
}
  803314:	c9                   	leaveq 
  803315:	c3                   	retq   

0000000000803316 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803316:	55                   	push   %rbp
  803317:	48 89 e5             	mov    %rsp,%rbp
  80331a:	48 83 ec 10          	sub    $0x10,%rsp
  80331e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803321:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803324:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80332b:	00 00 00 
  80332e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803331:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803333:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80333a:	00 00 00 
  80333d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803340:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803343:	bf 03 00 00 00       	mov    $0x3,%edi
  803348:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
}
  803354:	c9                   	leaveq 
  803355:	c3                   	retq   

0000000000803356 <nsipc_close>:

int
nsipc_close(int s)
{
  803356:	55                   	push   %rbp
  803357:	48 89 e5             	mov    %rsp,%rbp
  80335a:	48 83 ec 10          	sub    $0x10,%rsp
  80335e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803361:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803368:	00 00 00 
  80336b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80336e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803370:	bf 04 00 00 00       	mov    $0x4,%edi
  803375:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  80337c:	00 00 00 
  80337f:	ff d0                	callq  *%rax
}
  803381:	c9                   	leaveq 
  803382:	c3                   	retq   

0000000000803383 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803383:	55                   	push   %rbp
  803384:	48 89 e5             	mov    %rsp,%rbp
  803387:	48 83 ec 10          	sub    $0x10,%rsp
  80338b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80338e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803392:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803395:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80339c:	00 00 00 
  80339f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033a2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8033a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ab:	48 89 c6             	mov    %rax,%rsi
  8033ae:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8033b5:	00 00 00 
  8033b8:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8033bf:	00 00 00 
  8033c2:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8033c4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033cb:	00 00 00 
  8033ce:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033d1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033d4:	bf 05 00 00 00       	mov    $0x5,%edi
  8033d9:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  8033e0:	00 00 00 
  8033e3:	ff d0                	callq  *%rax
}
  8033e5:	c9                   	leaveq 
  8033e6:	c3                   	retq   

00000000008033e7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033e7:	55                   	push   %rbp
  8033e8:	48 89 e5             	mov    %rsp,%rbp
  8033eb:	48 83 ec 10          	sub    $0x10,%rsp
  8033ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033f2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8033f5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033fc:	00 00 00 
  8033ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803402:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803404:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80340b:	00 00 00 
  80340e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803411:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803414:	bf 06 00 00 00       	mov    $0x6,%edi
  803419:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
}
  803425:	c9                   	leaveq 
  803426:	c3                   	retq   

0000000000803427 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803427:	55                   	push   %rbp
  803428:	48 89 e5             	mov    %rsp,%rbp
  80342b:	48 83 ec 30          	sub    $0x30,%rsp
  80342f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803432:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803436:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803439:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80343c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803443:	00 00 00 
  803446:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803449:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80344b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803452:	00 00 00 
  803455:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803458:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80345b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803462:	00 00 00 
  803465:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803468:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80346b:	bf 07 00 00 00       	mov    $0x7,%edi
  803470:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803483:	78 69                	js     8034ee <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803485:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80348c:	7f 08                	jg     803496 <nsipc_recv+0x6f>
  80348e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803491:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803494:	7e 35                	jle    8034cb <nsipc_recv+0xa4>
  803496:	48 b9 6e 4f 80 00 00 	movabs $0x804f6e,%rcx
  80349d:	00 00 00 
  8034a0:	48 ba 83 4f 80 00 00 	movabs $0x804f83,%rdx
  8034a7:	00 00 00 
  8034aa:	be 62 00 00 00       	mov    $0x62,%esi
  8034af:	48 bf 98 4f 80 00 00 	movabs $0x804f98,%rdi
  8034b6:	00 00 00 
  8034b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034be:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  8034c5:	00 00 00 
  8034c8:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8034cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ce:	48 63 d0             	movslq %eax,%rdx
  8034d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d5:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8034dc:	00 00 00 
  8034df:	48 89 c7             	mov    %rax,%rdi
  8034e2:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
	}

	return r;
  8034ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034f1:	c9                   	leaveq 
  8034f2:	c3                   	retq   

00000000008034f3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8034f3:	55                   	push   %rbp
  8034f4:	48 89 e5             	mov    %rsp,%rbp
  8034f7:	48 83 ec 20          	sub    $0x20,%rsp
  8034fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803502:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803505:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803508:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80350f:	00 00 00 
  803512:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803515:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803517:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80351e:	7e 35                	jle    803555 <nsipc_send+0x62>
  803520:	48 b9 a4 4f 80 00 00 	movabs $0x804fa4,%rcx
  803527:	00 00 00 
  80352a:	48 ba 83 4f 80 00 00 	movabs $0x804f83,%rdx
  803531:	00 00 00 
  803534:	be 6d 00 00 00       	mov    $0x6d,%esi
  803539:	48 bf 98 4f 80 00 00 	movabs $0x804f98,%rdi
  803540:	00 00 00 
  803543:	b8 00 00 00 00       	mov    $0x0,%eax
  803548:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  80354f:	00 00 00 
  803552:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803555:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803558:	48 63 d0             	movslq %eax,%rdx
  80355b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355f:	48 89 c6             	mov    %rax,%rsi
  803562:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803569:	00 00 00 
  80356c:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803578:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80357f:	00 00 00 
  803582:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803585:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803588:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80358f:	00 00 00 
  803592:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803595:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803598:	bf 08 00 00 00       	mov    $0x8,%edi
  80359d:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  8035a4:	00 00 00 
  8035a7:	ff d0                	callq  *%rax
}
  8035a9:	c9                   	leaveq 
  8035aa:	c3                   	retq   

00000000008035ab <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8035ab:	55                   	push   %rbp
  8035ac:	48 89 e5             	mov    %rsp,%rbp
  8035af:	48 83 ec 10          	sub    $0x10,%rsp
  8035b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035b6:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8035b9:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8035bc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035c3:	00 00 00 
  8035c6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035c9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8035cb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035d2:	00 00 00 
  8035d5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035d8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8035db:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035e2:	00 00 00 
  8035e5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035e8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8035eb:	bf 09 00 00 00       	mov    $0x9,%edi
  8035f0:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
}
  8035fc:	c9                   	leaveq 
  8035fd:	c3                   	retq   

00000000008035fe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035fe:	55                   	push   %rbp
  8035ff:	48 89 e5             	mov    %rsp,%rbp
  803602:	53                   	push   %rbx
  803603:	48 83 ec 38          	sub    $0x38,%rsp
  803607:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80360b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80360f:	48 89 c7             	mov    %rax,%rdi
  803612:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  803619:	00 00 00 
  80361c:	ff d0                	callq  *%rax
  80361e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803621:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803625:	0f 88 bf 01 00 00    	js     8037ea <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80362b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362f:	ba 07 04 00 00       	mov    $0x407,%edx
  803634:	48 89 c6             	mov    %rax,%rsi
  803637:	bf 00 00 00 00       	mov    $0x0,%edi
  80363c:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80364b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80364f:	0f 88 95 01 00 00    	js     8037ea <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803655:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803659:	48 89 c7             	mov    %rax,%rdi
  80365c:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  803663:	00 00 00 
  803666:	ff d0                	callq  *%rax
  803668:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80366b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80366f:	0f 88 5d 01 00 00    	js     8037d2 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803675:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803679:	ba 07 04 00 00       	mov    $0x407,%edx
  80367e:	48 89 c6             	mov    %rax,%rsi
  803681:	bf 00 00 00 00       	mov    $0x0,%edi
  803686:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
  803692:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803695:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803699:	0f 88 33 01 00 00    	js     8037d2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80369f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a3:	48 89 c7             	mov    %rax,%rdi
  8036a6:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  8036ad:	00 00 00 
  8036b0:	ff d0                	callq  *%rax
  8036b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8036bf:	48 89 c6             	mov    %rax,%rsi
  8036c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c7:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
  8036d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036da:	79 05                	jns    8036e1 <pipe+0xe3>
		goto err2;
  8036dc:	e9 d9 00 00 00       	jmpq   8037ba <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e5:	48 89 c7             	mov    %rax,%rdi
  8036e8:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
  8036f4:	48 89 c2             	mov    %rax,%rdx
  8036f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036fb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803701:	48 89 d1             	mov    %rdx,%rcx
  803704:	ba 00 00 00 00       	mov    $0x0,%edx
  803709:	48 89 c6             	mov    %rax,%rsi
  80370c:	bf 00 00 00 00       	mov    $0x0,%edi
  803711:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  803718:	00 00 00 
  80371b:	ff d0                	callq  *%rax
  80371d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803720:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803724:	79 1b                	jns    803741 <pipe+0x143>
		goto err3;
  803726:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803727:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372b:	48 89 c6             	mov    %rax,%rsi
  80372e:	bf 00 00 00 00       	mov    $0x0,%edi
  803733:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
  80373f:	eb 79                	jmp    8037ba <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803745:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80374c:	00 00 00 
  80374f:	8b 12                	mov    (%rdx),%edx
  803751:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803757:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80375e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803762:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803769:	00 00 00 
  80376c:	8b 12                	mov    (%rdx),%edx
  80376e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803770:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803774:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80377b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80377f:	48 89 c7             	mov    %rax,%rdi
  803782:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
  80378e:	89 c2                	mov    %eax,%edx
  803790:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803794:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803796:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80379a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80379e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a2:	48 89 c7             	mov    %rax,%rdi
  8037a5:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  8037ac:	00 00 00 
  8037af:	ff d0                	callq  *%rax
  8037b1:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b8:	eb 33                	jmp    8037ed <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037be:	48 89 c6             	mov    %rax,%rsi
  8037c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c6:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d6:	48 89 c6             	mov    %rax,%rsi
  8037d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8037de:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  8037e5:	00 00 00 
  8037e8:	ff d0                	callq  *%rax
err:
	return r;
  8037ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037ed:	48 83 c4 38          	add    $0x38,%rsp
  8037f1:	5b                   	pop    %rbx
  8037f2:	5d                   	pop    %rbp
  8037f3:	c3                   	retq   

00000000008037f4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037f4:	55                   	push   %rbp
  8037f5:	48 89 e5             	mov    %rsp,%rbp
  8037f8:	53                   	push   %rbx
  8037f9:	48 83 ec 28          	sub    $0x28,%rsp
  8037fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803801:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803805:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80380c:	00 00 00 
  80380f:	48 8b 00             	mov    (%rax),%rax
  803812:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803818:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80381b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381f:	48 89 c7             	mov    %rax,%rdi
  803822:	48 b8 cd 42 80 00 00 	movabs $0x8042cd,%rax
  803829:	00 00 00 
  80382c:	ff d0                	callq  *%rax
  80382e:	89 c3                	mov    %eax,%ebx
  803830:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803834:	48 89 c7             	mov    %rax,%rdi
  803837:	48 b8 cd 42 80 00 00 	movabs $0x8042cd,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
  803843:	39 c3                	cmp    %eax,%ebx
  803845:	0f 94 c0             	sete   %al
  803848:	0f b6 c0             	movzbl %al,%eax
  80384b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80384e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803855:	00 00 00 
  803858:	48 8b 00             	mov    (%rax),%rax
  80385b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803861:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803864:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803867:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80386a:	75 05                	jne    803871 <_pipeisclosed+0x7d>
			return ret;
  80386c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80386f:	eb 4f                	jmp    8038c0 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803871:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803874:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803877:	74 42                	je     8038bb <_pipeisclosed+0xc7>
  803879:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80387d:	75 3c                	jne    8038bb <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80387f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803886:	00 00 00 
  803889:	48 8b 00             	mov    (%rax),%rax
  80388c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803892:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803895:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803898:	89 c6                	mov    %eax,%esi
  80389a:	48 bf b5 4f 80 00 00 	movabs $0x804fb5,%rdi
  8038a1:	00 00 00 
  8038a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a9:	49 b8 03 05 80 00 00 	movabs $0x800503,%r8
  8038b0:	00 00 00 
  8038b3:	41 ff d0             	callq  *%r8
	}
  8038b6:	e9 4a ff ff ff       	jmpq   803805 <_pipeisclosed+0x11>
  8038bb:	e9 45 ff ff ff       	jmpq   803805 <_pipeisclosed+0x11>

}
  8038c0:	48 83 c4 28          	add    $0x28,%rsp
  8038c4:	5b                   	pop    %rbx
  8038c5:	5d                   	pop    %rbp
  8038c6:	c3                   	retq   

00000000008038c7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038c7:	55                   	push   %rbp
  8038c8:	48 89 e5             	mov    %rsp,%rbp
  8038cb:	48 83 ec 30          	sub    $0x30,%rsp
  8038cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038d2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038d6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038d9:	48 89 d6             	mov    %rdx,%rsi
  8038dc:	89 c7                	mov    %eax,%edi
  8038de:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  8038e5:	00 00 00 
  8038e8:	ff d0                	callq  *%rax
  8038ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f1:	79 05                	jns    8038f8 <pipeisclosed+0x31>
		return r;
  8038f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f6:	eb 31                	jmp    803929 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fc:	48 89 c7             	mov    %rax,%rdi
  8038ff:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  803906:	00 00 00 
  803909:	ff d0                	callq  *%rax
  80390b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80390f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803913:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803917:	48 89 d6             	mov    %rdx,%rsi
  80391a:	48 89 c7             	mov    %rax,%rdi
  80391d:	48 b8 f4 37 80 00 00 	movabs $0x8037f4,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
}
  803929:	c9                   	leaveq 
  80392a:	c3                   	retq   

000000000080392b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80392b:	55                   	push   %rbp
  80392c:	48 89 e5             	mov    %rsp,%rbp
  80392f:	48 83 ec 40          	sub    $0x40,%rsp
  803933:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803937:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80393b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80393f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803943:	48 89 c7             	mov    %rax,%rdi
  803946:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
  803952:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803956:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80395a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80395e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803965:	00 
  803966:	e9 92 00 00 00       	jmpq   8039fd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80396b:	eb 41                	jmp    8039ae <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80396d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803972:	74 09                	je     80397d <devpipe_read+0x52>
				return i;
  803974:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803978:	e9 92 00 00 00       	jmpq   803a0f <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80397d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803985:	48 89 d6             	mov    %rdx,%rsi
  803988:	48 89 c7             	mov    %rax,%rdi
  80398b:	48 b8 f4 37 80 00 00 	movabs $0x8037f4,%rax
  803992:	00 00 00 
  803995:	ff d0                	callq  *%rax
  803997:	85 c0                	test   %eax,%eax
  803999:	74 07                	je     8039a2 <devpipe_read+0x77>
				return 0;
  80399b:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a0:	eb 6d                	jmp    803a0f <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039a2:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b2:	8b 10                	mov    (%rax),%edx
  8039b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b8:	8b 40 04             	mov    0x4(%rax),%eax
  8039bb:	39 c2                	cmp    %eax,%edx
  8039bd:	74 ae                	je     80396d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039cf:	8b 00                	mov    (%rax),%eax
  8039d1:	99                   	cltd   
  8039d2:	c1 ea 1b             	shr    $0x1b,%edx
  8039d5:	01 d0                	add    %edx,%eax
  8039d7:	83 e0 1f             	and    $0x1f,%eax
  8039da:	29 d0                	sub    %edx,%eax
  8039dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039e0:	48 98                	cltq   
  8039e2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039e7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ed:	8b 00                	mov    (%rax),%eax
  8039ef:	8d 50 01             	lea    0x1(%rax),%edx
  8039f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a01:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a05:	0f 82 60 ff ff ff    	jb     80396b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803a0f:	c9                   	leaveq 
  803a10:	c3                   	retq   

0000000000803a11 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a11:	55                   	push   %rbp
  803a12:	48 89 e5             	mov    %rsp,%rbp
  803a15:	48 83 ec 40          	sub    $0x40,%rsp
  803a19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a29:	48 89 c7             	mov    %rax,%rdi
  803a2c:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
  803a38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a44:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a4b:	00 
  803a4c:	e9 8e 00 00 00       	jmpq   803adf <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a51:	eb 31                	jmp    803a84 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5b:	48 89 d6             	mov    %rdx,%rsi
  803a5e:	48 89 c7             	mov    %rax,%rdi
  803a61:	48 b8 f4 37 80 00 00 	movabs $0x8037f4,%rax
  803a68:	00 00 00 
  803a6b:	ff d0                	callq  *%rax
  803a6d:	85 c0                	test   %eax,%eax
  803a6f:	74 07                	je     803a78 <devpipe_write+0x67>
				return 0;
  803a71:	b8 00 00 00 00       	mov    $0x0,%eax
  803a76:	eb 79                	jmp    803af1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a78:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  803a7f:	00 00 00 
  803a82:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a88:	8b 40 04             	mov    0x4(%rax),%eax
  803a8b:	48 63 d0             	movslq %eax,%rdx
  803a8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a92:	8b 00                	mov    (%rax),%eax
  803a94:	48 98                	cltq   
  803a96:	48 83 c0 20          	add    $0x20,%rax
  803a9a:	48 39 c2             	cmp    %rax,%rdx
  803a9d:	73 b4                	jae    803a53 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa3:	8b 40 04             	mov    0x4(%rax),%eax
  803aa6:	99                   	cltd   
  803aa7:	c1 ea 1b             	shr    $0x1b,%edx
  803aaa:	01 d0                	add    %edx,%eax
  803aac:	83 e0 1f             	and    $0x1f,%eax
  803aaf:	29 d0                	sub    %edx,%eax
  803ab1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ab5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ab9:	48 01 ca             	add    %rcx,%rdx
  803abc:	0f b6 0a             	movzbl (%rdx),%ecx
  803abf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac3:	48 98                	cltq   
  803ac5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ac9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803acd:	8b 40 04             	mov    0x4(%rax),%eax
  803ad0:	8d 50 01             	lea    0x1(%rax),%edx
  803ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ada:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ae7:	0f 82 64 ff ff ff    	jb     803a51 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803af1:	c9                   	leaveq 
  803af2:	c3                   	retq   

0000000000803af3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803af3:	55                   	push   %rbp
  803af4:	48 89 e5             	mov    %rsp,%rbp
  803af7:	48 83 ec 20          	sub    $0x20,%rsp
  803afb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803aff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b07:	48 89 c7             	mov    %rax,%rdi
  803b0a:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  803b11:	00 00 00 
  803b14:	ff d0                	callq  *%rax
  803b16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b1e:	48 be c8 4f 80 00 00 	movabs $0x804fc8,%rsi
  803b25:	00 00 00 
  803b28:	48 89 c7             	mov    %rax,%rdi
  803b2b:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b3b:	8b 50 04             	mov    0x4(%rax),%edx
  803b3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b42:	8b 00                	mov    (%rax),%eax
  803b44:	29 c2                	sub    %eax,%edx
  803b46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b54:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b5b:	00 00 00 
	stat->st_dev = &devpipe;
  803b5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b62:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  803b69:	00 00 00 
  803b6c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b78:	c9                   	leaveq 
  803b79:	c3                   	retq   

0000000000803b7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b7a:	55                   	push   %rbp
  803b7b:	48 89 e5             	mov    %rsp,%rbp
  803b7e:	48 83 ec 10          	sub    $0x10,%rsp
  803b82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8a:	48 89 c6             	mov    %rax,%rsi
  803b8d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b92:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba2:	48 89 c7             	mov    %rax,%rdi
  803ba5:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  803bac:	00 00 00 
  803baf:	ff d0                	callq  *%rax
  803bb1:	48 89 c6             	mov    %rax,%rsi
  803bb4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb9:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
}
  803bc5:	c9                   	leaveq 
  803bc6:	c3                   	retq   

0000000000803bc7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bc7:	55                   	push   %rbp
  803bc8:	48 89 e5             	mov    %rsp,%rbp
  803bcb:	48 83 ec 20          	sub    $0x20,%rsp
  803bcf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd5:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bd8:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bdc:	be 01 00 00 00       	mov    $0x1,%esi
  803be1:	48 89 c7             	mov    %rax,%rdi
  803be4:	48 b8 9f 18 80 00 00 	movabs $0x80189f,%rax
  803beb:	00 00 00 
  803bee:	ff d0                	callq  *%rax
}
  803bf0:	c9                   	leaveq 
  803bf1:	c3                   	retq   

0000000000803bf2 <getchar>:

int
getchar(void)
{
  803bf2:	55                   	push   %rbp
  803bf3:	48 89 e5             	mov    %rsp,%rbp
  803bf6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bfa:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803bfe:	ba 01 00 00 00       	mov    $0x1,%edx
  803c03:	48 89 c6             	mov    %rax,%rsi
  803c06:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0b:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  803c12:	00 00 00 
  803c15:	ff d0                	callq  *%rax
  803c17:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1e:	79 05                	jns    803c25 <getchar+0x33>
		return r;
  803c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c23:	eb 14                	jmp    803c39 <getchar+0x47>
	if (r < 1)
  803c25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c29:	7f 07                	jg     803c32 <getchar+0x40>
		return -E_EOF;
  803c2b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c30:	eb 07                	jmp    803c39 <getchar+0x47>
	return c;
  803c32:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c36:	0f b6 c0             	movzbl %al,%eax

}
  803c39:	c9                   	leaveq 
  803c3a:	c3                   	retq   

0000000000803c3b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c3b:	55                   	push   %rbp
  803c3c:	48 89 e5             	mov    %rsp,%rbp
  803c3f:	48 83 ec 20          	sub    $0x20,%rsp
  803c43:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c46:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4d:	48 89 d6             	mov    %rdx,%rsi
  803c50:	89 c7                	mov    %eax,%edi
  803c52:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803c59:	00 00 00 
  803c5c:	ff d0                	callq  *%rax
  803c5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c65:	79 05                	jns    803c6c <iscons+0x31>
		return r;
  803c67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6a:	eb 1a                	jmp    803c86 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c70:	8b 10                	mov    (%rax),%edx
  803c72:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803c79:	00 00 00 
  803c7c:	8b 00                	mov    (%rax),%eax
  803c7e:	39 c2                	cmp    %eax,%edx
  803c80:	0f 94 c0             	sete   %al
  803c83:	0f b6 c0             	movzbl %al,%eax
}
  803c86:	c9                   	leaveq 
  803c87:	c3                   	retq   

0000000000803c88 <opencons>:

int
opencons(void)
{
  803c88:	55                   	push   %rbp
  803c89:	48 89 e5             	mov    %rsp,%rbp
  803c8c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c90:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c94:	48 89 c7             	mov    %rax,%rdi
  803c97:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
  803ca3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803caa:	79 05                	jns    803cb1 <opencons+0x29>
		return r;
  803cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803caf:	eb 5b                	jmp    803d0c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb5:	ba 07 04 00 00       	mov    $0x407,%edx
  803cba:	48 89 c6             	mov    %rax,%rsi
  803cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc2:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
  803cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd5:	79 05                	jns    803cdc <opencons+0x54>
		return r;
  803cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cda:	eb 30                	jmp    803d0c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce0:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  803ce7:	00 00 00 
  803cea:	8b 12                	mov    (%rdx),%edx
  803cec:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfd:	48 89 c7             	mov    %rax,%rdi
  803d00:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  803d07:	00 00 00 
  803d0a:	ff d0                	callq  *%rax
}
  803d0c:	c9                   	leaveq 
  803d0d:	c3                   	retq   

0000000000803d0e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d0e:	55                   	push   %rbp
  803d0f:	48 89 e5             	mov    %rsp,%rbp
  803d12:	48 83 ec 30          	sub    $0x30,%rsp
  803d16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d22:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d27:	75 07                	jne    803d30 <devcons_read+0x22>
		return 0;
  803d29:	b8 00 00 00 00       	mov    $0x0,%eax
  803d2e:	eb 4b                	jmp    803d7b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d30:	eb 0c                	jmp    803d3e <devcons_read+0x30>
		sys_yield();
  803d32:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  803d39:	00 00 00 
  803d3c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d3e:	48 b8 e9 18 80 00 00 	movabs $0x8018e9,%rax
  803d45:	00 00 00 
  803d48:	ff d0                	callq  *%rax
  803d4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d51:	74 df                	je     803d32 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d57:	79 05                	jns    803d5e <devcons_read+0x50>
		return c;
  803d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5c:	eb 1d                	jmp    803d7b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d5e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d62:	75 07                	jne    803d6b <devcons_read+0x5d>
		return 0;
  803d64:	b8 00 00 00 00       	mov    $0x0,%eax
  803d69:	eb 10                	jmp    803d7b <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6e:	89 c2                	mov    %eax,%edx
  803d70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d74:	88 10                	mov    %dl,(%rax)
	return 1;
  803d76:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d7b:	c9                   	leaveq 
  803d7c:	c3                   	retq   

0000000000803d7d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d7d:	55                   	push   %rbp
  803d7e:	48 89 e5             	mov    %rsp,%rbp
  803d81:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d88:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d8f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d96:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803da4:	eb 76                	jmp    803e1c <devcons_write+0x9f>
		m = n - tot;
  803da6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dad:	89 c2                	mov    %eax,%edx
  803daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db2:	29 c2                	sub    %eax,%edx
  803db4:	89 d0                	mov    %edx,%eax
  803db6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803db9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dbc:	83 f8 7f             	cmp    $0x7f,%eax
  803dbf:	76 07                	jbe    803dc8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dc1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803dc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dcb:	48 63 d0             	movslq %eax,%rdx
  803dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd1:	48 63 c8             	movslq %eax,%rcx
  803dd4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ddb:	48 01 c1             	add    %rax,%rcx
  803dde:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803de5:	48 89 ce             	mov    %rcx,%rsi
  803de8:	48 89 c7             	mov    %rax,%rdi
  803deb:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  803df2:	00 00 00 
  803df5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803df7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dfa:	48 63 d0             	movslq %eax,%rdx
  803dfd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e04:	48 89 d6             	mov    %rdx,%rsi
  803e07:	48 89 c7             	mov    %rax,%rdi
  803e0a:	48 b8 9f 18 80 00 00 	movabs $0x80189f,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e19:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1f:	48 98                	cltq   
  803e21:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e28:	0f 82 78 ff ff ff    	jb     803da6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e31:	c9                   	leaveq 
  803e32:	c3                   	retq   

0000000000803e33 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e33:	55                   	push   %rbp
  803e34:	48 89 e5             	mov    %rsp,%rbp
  803e37:	48 83 ec 08          	sub    $0x8,%rsp
  803e3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e44:	c9                   	leaveq 
  803e45:	c3                   	retq   

0000000000803e46 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e46:	55                   	push   %rbp
  803e47:	48 89 e5             	mov    %rsp,%rbp
  803e4a:	48 83 ec 10          	sub    $0x10,%rsp
  803e4e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5a:	48 be d4 4f 80 00 00 	movabs $0x804fd4,%rsi
  803e61:	00 00 00 
  803e64:	48 89 c7             	mov    %rax,%rdi
  803e67:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  803e6e:	00 00 00 
  803e71:	ff d0                	callq  *%rax
	return 0;
  803e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e78:	c9                   	leaveq 
  803e79:	c3                   	retq   

0000000000803e7a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803e7a:	55                   	push   %rbp
  803e7b:	48 89 e5             	mov    %rsp,%rbp
  803e7e:	53                   	push   %rbx
  803e7f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803e86:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803e8d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803e93:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803e9a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803ea1:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ea8:	84 c0                	test   %al,%al
  803eaa:	74 23                	je     803ecf <_panic+0x55>
  803eac:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803eb3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803eb7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803ebb:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803ebf:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803ec3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803ec7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803ecb:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803ecf:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803ed6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803edd:	00 00 00 
  803ee0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803ee7:	00 00 00 
  803eea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803eee:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803ef5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803efc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803f03:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803f0a:	00 00 00 
  803f0d:	48 8b 18             	mov    (%rax),%rbx
  803f10:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
  803f1c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803f22:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803f29:	41 89 c8             	mov    %ecx,%r8d
  803f2c:	48 89 d1             	mov    %rdx,%rcx
  803f2f:	48 89 da             	mov    %rbx,%rdx
  803f32:	89 c6                	mov    %eax,%esi
  803f34:	48 bf e0 4f 80 00 00 	movabs $0x804fe0,%rdi
  803f3b:	00 00 00 
  803f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f43:	49 b9 03 05 80 00 00 	movabs $0x800503,%r9
  803f4a:	00 00 00 
  803f4d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803f50:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803f57:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f5e:	48 89 d6             	mov    %rdx,%rsi
  803f61:	48 89 c7             	mov    %rax,%rdi
  803f64:	48 b8 57 04 80 00 00 	movabs $0x800457,%rax
  803f6b:	00 00 00 
  803f6e:	ff d0                	callq  *%rax
	cprintf("\n");
  803f70:	48 bf 03 50 80 00 00 	movabs $0x805003,%rdi
  803f77:	00 00 00 
  803f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7f:	48 ba 03 05 80 00 00 	movabs $0x800503,%rdx
  803f86:	00 00 00 
  803f89:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803f8b:	cc                   	int3   
  803f8c:	eb fd                	jmp    803f8b <_panic+0x111>

0000000000803f8e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f8e:	55                   	push   %rbp
  803f8f:	48 89 e5             	mov    %rsp,%rbp
  803f92:	48 83 ec 30          	sub    $0x30,%rsp
  803f96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f9e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803fa2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fa7:	75 0e                	jne    803fb7 <ipc_recv+0x29>
		pg = (void*) UTOP;
  803fa9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fb0:	00 00 00 
  803fb3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803fb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fbb:	48 89 c7             	mov    %rax,%rdi
  803fbe:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  803fc5:	00 00 00 
  803fc8:	ff d0                	callq  *%rax
  803fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd1:	79 27                	jns    803ffa <ipc_recv+0x6c>
		if (from_env_store)
  803fd3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fd8:	74 0a                	je     803fe4 <ipc_recv+0x56>
			*from_env_store = 0;
  803fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fde:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803fe4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fe9:	74 0a                	je     803ff5 <ipc_recv+0x67>
			*perm_store = 0;
  803feb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fef:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff8:	eb 53                	jmp    80404d <ipc_recv+0xbf>
	}
	if (from_env_store)
  803ffa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fff:	74 19                	je     80401a <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804001:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804008:	00 00 00 
  80400b:	48 8b 00             	mov    (%rax),%rax
  80400e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804018:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80401a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80401f:	74 19                	je     80403a <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804021:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804028:	00 00 00 
  80402b:	48 8b 00             	mov    (%rax),%rax
  80402e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804034:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804038:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80403a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804041:	00 00 00 
  804044:	48 8b 00             	mov    (%rax),%rax
  804047:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80404d:	c9                   	leaveq 
  80404e:	c3                   	retq   

000000000080404f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80404f:	55                   	push   %rbp
  804050:	48 89 e5             	mov    %rsp,%rbp
  804053:	48 83 ec 30          	sub    $0x30,%rsp
  804057:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80405a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80405d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804061:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804064:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804069:	75 10                	jne    80407b <ipc_send+0x2c>
		pg = (void*) UTOP;
  80406b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804072:	00 00 00 
  804075:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804079:	eb 0e                	jmp    804089 <ipc_send+0x3a>
  80407b:	eb 0c                	jmp    804089 <ipc_send+0x3a>
		sys_yield();
  80407d:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  804084:	00 00 00 
  804087:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804089:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80408c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80408f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804093:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804096:	89 c7                	mov    %eax,%edi
  804098:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  80409f:	00 00 00 
  8040a2:	ff d0                	callq  *%rax
  8040a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8040ab:	74 d0                	je     80407d <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  8040ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b1:	79 30                	jns    8040e3 <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  8040b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b6:	89 c1                	mov    %eax,%ecx
  8040b8:	48 ba 05 50 80 00 00 	movabs $0x805005,%rdx
  8040bf:	00 00 00 
  8040c2:	be 47 00 00 00       	mov    $0x47,%esi
  8040c7:	48 bf 1b 50 80 00 00 	movabs $0x80501b,%rdi
  8040ce:	00 00 00 
  8040d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d6:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  8040dd:	00 00 00 
  8040e0:	41 ff d0             	callq  *%r8

}
  8040e3:	c9                   	leaveq 
  8040e4:	c3                   	retq   

00000000008040e5 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8040e5:	55                   	push   %rbp
  8040e6:	48 89 e5             	mov    %rsp,%rbp
  8040e9:	53                   	push   %rbx
  8040ea:	48 83 ec 28          	sub    $0x28,%rsp
  8040ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8040f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8040f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804100:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804105:	75 0e                	jne    804115 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804107:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80410e:	00 00 00 
  804111:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804115:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804119:	ba 07 00 00 00       	mov    $0x7,%edx
  80411e:	48 89 c6             	mov    %rax,%rsi
  804121:	bf 00 00 00 00       	mov    $0x0,%edi
  804126:	48 b8 e7 19 80 00 00 	movabs $0x8019e7,%rax
  80412d:	00 00 00 
  804130:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804136:	48 c1 e8 0c          	shr    $0xc,%rax
  80413a:	48 89 c2             	mov    %rax,%rdx
  80413d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804144:	01 00 00 
  804147:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80414b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804151:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804155:	b8 03 00 00 00       	mov    $0x3,%eax
  80415a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80415e:	48 89 d3             	mov    %rdx,%rbx
  804161:	0f 01 c1             	vmcall 
  804164:	89 f2                	mov    %esi,%edx
  804166:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804169:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  80416c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804170:	79 05                	jns    804177 <ipc_host_recv+0x92>
		return r;
  804172:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804175:	eb 03                	jmp    80417a <ipc_host_recv+0x95>
	}
	return val;
  804177:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80417a:	48 83 c4 28          	add    $0x28,%rsp
  80417e:	5b                   	pop    %rbx
  80417f:	5d                   	pop    %rbp
  804180:	c3                   	retq   

0000000000804181 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804181:	55                   	push   %rbp
  804182:	48 89 e5             	mov    %rsp,%rbp
  804185:	53                   	push   %rbx
  804186:	48 83 ec 38          	sub    $0x38,%rsp
  80418a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80418d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804190:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804194:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804197:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80419e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8041a3:	75 0e                	jne    8041b3 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8041a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041ac:	00 00 00 
  8041af:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8041b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8041bb:	48 89 c2             	mov    %rax,%rdx
  8041be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041c5:	01 00 00 
  8041c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041cc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8041d2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8041d6:	b8 02 00 00 00       	mov    $0x2,%eax
  8041db:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8041de:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8041e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041e5:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8041e8:	89 fb                	mov    %edi,%ebx
  8041ea:	0f 01 c1             	vmcall 
  8041ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8041f0:	eb 26                	jmp    804218 <ipc_host_send+0x97>
		sys_yield();
  8041f2:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  8041f9:	00 00 00 
  8041fc:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8041fe:	b8 02 00 00 00       	mov    $0x2,%eax
  804203:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804206:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804209:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80420d:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804210:	89 fb                	mov    %edi,%ebx
  804212:	0f 01 c1             	vmcall 
  804215:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804218:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  80421c:	74 d4                	je     8041f2 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  80421e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804222:	79 30                	jns    804254 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804224:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804227:	89 c1                	mov    %eax,%ecx
  804229:	48 ba 05 50 80 00 00 	movabs $0x805005,%rdx
  804230:	00 00 00 
  804233:	be 79 00 00 00       	mov    $0x79,%esi
  804238:	48 bf 1b 50 80 00 00 	movabs $0x80501b,%rdi
  80423f:	00 00 00 
  804242:	b8 00 00 00 00       	mov    $0x0,%eax
  804247:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  80424e:	00 00 00 
  804251:	41 ff d0             	callq  *%r8

}
  804254:	48 83 c4 38          	add    $0x38,%rsp
  804258:	5b                   	pop    %rbx
  804259:	5d                   	pop    %rbp
  80425a:	c3                   	retq   

000000000080425b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80425b:	55                   	push   %rbp
  80425c:	48 89 e5             	mov    %rsp,%rbp
  80425f:	48 83 ec 14          	sub    $0x14,%rsp
  804263:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80426d:	eb 4e                	jmp    8042bd <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80426f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804276:	00 00 00 
  804279:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427c:	48 98                	cltq   
  80427e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804285:	48 01 d0             	add    %rdx,%rax
  804288:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80428e:	8b 00                	mov    (%rax),%eax
  804290:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804293:	75 24                	jne    8042b9 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804295:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80429c:	00 00 00 
  80429f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a2:	48 98                	cltq   
  8042a4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8042ab:	48 01 d0             	add    %rdx,%rax
  8042ae:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8042b4:	8b 40 08             	mov    0x8(%rax),%eax
  8042b7:	eb 12                	jmp    8042cb <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8042b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8042bd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8042c4:	7e a9                	jle    80426f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8042c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042cb:	c9                   	leaveq 
  8042cc:	c3                   	retq   

00000000008042cd <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8042cd:	55                   	push   %rbp
  8042ce:	48 89 e5             	mov    %rsp,%rbp
  8042d1:	48 83 ec 18          	sub    $0x18,%rsp
  8042d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8042d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042dd:	48 c1 e8 15          	shr    $0x15,%rax
  8042e1:	48 89 c2             	mov    %rax,%rdx
  8042e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042eb:	01 00 00 
  8042ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042f2:	83 e0 01             	and    $0x1,%eax
  8042f5:	48 85 c0             	test   %rax,%rax
  8042f8:	75 07                	jne    804301 <pageref+0x34>
		return 0;
  8042fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ff:	eb 53                	jmp    804354 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804305:	48 c1 e8 0c          	shr    $0xc,%rax
  804309:	48 89 c2             	mov    %rax,%rdx
  80430c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804313:	01 00 00 
  804316:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80431a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80431e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804322:	83 e0 01             	and    $0x1,%eax
  804325:	48 85 c0             	test   %rax,%rax
  804328:	75 07                	jne    804331 <pageref+0x64>
		return 0;
  80432a:	b8 00 00 00 00       	mov    $0x0,%eax
  80432f:	eb 23                	jmp    804354 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804335:	48 c1 e8 0c          	shr    $0xc,%rax
  804339:	48 89 c2             	mov    %rax,%rdx
  80433c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804343:	00 00 00 
  804346:	48 c1 e2 04          	shl    $0x4,%rdx
  80434a:	48 01 d0             	add    %rdx,%rax
  80434d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804351:	0f b7 c0             	movzwl %ax,%eax
}
  804354:	c9                   	leaveq 
  804355:	c3                   	retq   

0000000000804356 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804356:	55                   	push   %rbp
  804357:	48 89 e5             	mov    %rsp,%rbp
  80435a:	48 83 ec 20          	sub    $0x20,%rsp
  80435e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804362:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80436a:	48 89 d6             	mov    %rdx,%rsi
  80436d:	48 89 c7             	mov    %rax,%rdi
  804370:	48 b8 8c 43 80 00 00 	movabs $0x80438c,%rax
  804377:	00 00 00 
  80437a:	ff d0                	callq  *%rax
  80437c:	85 c0                	test   %eax,%eax
  80437e:	74 05                	je     804385 <inet_addr+0x2f>
    return (val.s_addr);
  804380:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804383:	eb 05                	jmp    80438a <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80438a:	c9                   	leaveq 
  80438b:	c3                   	retq   

000000000080438c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80438c:	55                   	push   %rbp
  80438d:	48 89 e5             	mov    %rsp,%rbp
  804390:	48 83 ec 40          	sub    $0x40,%rsp
  804394:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804398:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80439c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8043a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  8043a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043a8:	0f b6 00             	movzbl (%rax),%eax
  8043ab:	0f be c0             	movsbl %al,%eax
  8043ae:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8043b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043b4:	3c 2f                	cmp    $0x2f,%al
  8043b6:	76 07                	jbe    8043bf <inet_aton+0x33>
  8043b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043bb:	3c 39                	cmp    $0x39,%al
  8043bd:	76 0a                	jbe    8043c9 <inet_aton+0x3d>
      return (0);
  8043bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c4:	e9 68 02 00 00       	jmpq   804631 <inet_aton+0x2a5>
    val = 0;
  8043c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8043d0:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  8043d7:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8043db:	75 40                	jne    80441d <inet_aton+0x91>
      c = *++cp;
  8043dd:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8043e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043e6:	0f b6 00             	movzbl (%rax),%eax
  8043e9:	0f be c0             	movsbl %al,%eax
  8043ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8043ef:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8043f3:	74 06                	je     8043fb <inet_aton+0x6f>
  8043f5:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  8043f9:	75 1b                	jne    804416 <inet_aton+0x8a>
        base = 16;
  8043fb:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804402:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804407:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80440b:	0f b6 00             	movzbl (%rax),%eax
  80440e:	0f be c0             	movsbl %al,%eax
  804411:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804414:	eb 07                	jmp    80441d <inet_aton+0x91>
      } else
        base = 8;
  804416:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80441d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804420:	3c 2f                	cmp    $0x2f,%al
  804422:	76 2f                	jbe    804453 <inet_aton+0xc7>
  804424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804427:	3c 39                	cmp    $0x39,%al
  804429:	77 28                	ja     804453 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  80442b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80442e:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804432:	89 c2                	mov    %eax,%edx
  804434:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804437:	01 d0                	add    %edx,%eax
  804439:	83 e8 30             	sub    $0x30,%eax
  80443c:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80443f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804444:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804448:	0f b6 00             	movzbl (%rax),%eax
  80444b:	0f be c0             	movsbl %al,%eax
  80444e:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804451:	eb ca                	jmp    80441d <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804453:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  804457:	75 72                	jne    8044cb <inet_aton+0x13f>
  804459:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80445c:	3c 2f                	cmp    $0x2f,%al
  80445e:	76 07                	jbe    804467 <inet_aton+0xdb>
  804460:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804463:	3c 39                	cmp    $0x39,%al
  804465:	76 1c                	jbe    804483 <inet_aton+0xf7>
  804467:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80446a:	3c 60                	cmp    $0x60,%al
  80446c:	76 07                	jbe    804475 <inet_aton+0xe9>
  80446e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804471:	3c 66                	cmp    $0x66,%al
  804473:	76 0e                	jbe    804483 <inet_aton+0xf7>
  804475:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804478:	3c 40                	cmp    $0x40,%al
  80447a:	76 4f                	jbe    8044cb <inet_aton+0x13f>
  80447c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80447f:	3c 46                	cmp    $0x46,%al
  804481:	77 48                	ja     8044cb <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804486:	c1 e0 04             	shl    $0x4,%eax
  804489:	89 c2                	mov    %eax,%edx
  80448b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80448e:	8d 48 0a             	lea    0xa(%rax),%ecx
  804491:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804494:	3c 60                	cmp    $0x60,%al
  804496:	76 0e                	jbe    8044a6 <inet_aton+0x11a>
  804498:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80449b:	3c 7a                	cmp    $0x7a,%al
  80449d:	77 07                	ja     8044a6 <inet_aton+0x11a>
  80449f:	b8 61 00 00 00       	mov    $0x61,%eax
  8044a4:	eb 05                	jmp    8044ab <inet_aton+0x11f>
  8044a6:	b8 41 00 00 00       	mov    $0x41,%eax
  8044ab:	29 c1                	sub    %eax,%ecx
  8044ad:	89 c8                	mov    %ecx,%eax
  8044af:	09 d0                	or     %edx,%eax
  8044b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8044b4:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8044b9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044bd:	0f b6 00             	movzbl (%rax),%eax
  8044c0:	0f be c0             	movsbl %al,%eax
  8044c3:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8044c6:	e9 52 ff ff ff       	jmpq   80441d <inet_aton+0x91>
    if (c == '.') {
  8044cb:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  8044cf:	75 40                	jne    804511 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8044d1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8044d5:	48 83 c0 0c          	add    $0xc,%rax
  8044d9:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8044dd:	72 0a                	jb     8044e9 <inet_aton+0x15d>
        return (0);
  8044df:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e4:	e9 48 01 00 00       	jmpq   804631 <inet_aton+0x2a5>
      *pp++ = val;
  8044e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ed:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8044f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8044f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044f8:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  8044fa:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8044ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804503:	0f b6 00             	movzbl (%rax),%eax
  804506:	0f be c0             	movsbl %al,%eax
  804509:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  80450c:	e9 a0 fe ff ff       	jmpq   8043b1 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804511:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804512:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804516:	74 3c                	je     804554 <inet_aton+0x1c8>
  804518:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80451b:	3c 1f                	cmp    $0x1f,%al
  80451d:	76 2b                	jbe    80454a <inet_aton+0x1be>
  80451f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804522:	84 c0                	test   %al,%al
  804524:	78 24                	js     80454a <inet_aton+0x1be>
  804526:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80452a:	74 28                	je     804554 <inet_aton+0x1c8>
  80452c:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804530:	74 22                	je     804554 <inet_aton+0x1c8>
  804532:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804536:	74 1c                	je     804554 <inet_aton+0x1c8>
  804538:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80453c:	74 16                	je     804554 <inet_aton+0x1c8>
  80453e:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804542:	74 10                	je     804554 <inet_aton+0x1c8>
  804544:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804548:	74 0a                	je     804554 <inet_aton+0x1c8>
    return (0);
  80454a:	b8 00 00 00 00       	mov    $0x0,%eax
  80454f:	e9 dd 00 00 00       	jmpq   804631 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804554:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804558:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80455c:	48 29 c2             	sub    %rax,%rdx
  80455f:	48 89 d0             	mov    %rdx,%rax
  804562:	48 c1 f8 02          	sar    $0x2,%rax
  804566:	83 c0 01             	add    $0x1,%eax
  804569:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80456c:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804570:	0f 87 98 00 00 00    	ja     80460e <inet_aton+0x282>
  804576:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804579:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804580:	00 
  804581:	48 b8 28 50 80 00 00 	movabs $0x805028,%rax
  804588:	00 00 00 
  80458b:	48 01 d0             	add    %rdx,%rax
  80458e:	48 8b 00             	mov    (%rax),%rax
  804591:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804593:	b8 00 00 00 00       	mov    $0x0,%eax
  804598:	e9 94 00 00 00       	jmpq   804631 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  80459d:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8045a4:	76 0a                	jbe    8045b0 <inet_aton+0x224>
      return (0);
  8045a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ab:	e9 81 00 00 00       	jmpq   804631 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  8045b0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045b3:	c1 e0 18             	shl    $0x18,%eax
  8045b6:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045b9:	eb 53                	jmp    80460e <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8045bb:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8045c2:	76 07                	jbe    8045cb <inet_aton+0x23f>
      return (0);
  8045c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c9:	eb 66                	jmp    804631 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8045cb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045ce:	c1 e0 18             	shl    $0x18,%eax
  8045d1:	89 c2                	mov    %eax,%edx
  8045d3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8045d6:	c1 e0 10             	shl    $0x10,%eax
  8045d9:	09 d0                	or     %edx,%eax
  8045db:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045de:	eb 2e                	jmp    80460e <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8045e0:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  8045e7:	76 07                	jbe    8045f0 <inet_aton+0x264>
      return (0);
  8045e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ee:	eb 41                	jmp    804631 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8045f0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045f3:	c1 e0 18             	shl    $0x18,%eax
  8045f6:	89 c2                	mov    %eax,%edx
  8045f8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8045fb:	c1 e0 10             	shl    $0x10,%eax
  8045fe:	09 c2                	or     %eax,%edx
  804600:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804603:	c1 e0 08             	shl    $0x8,%eax
  804606:	09 d0                	or     %edx,%eax
  804608:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80460b:	eb 01                	jmp    80460e <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  80460d:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  80460e:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804613:	74 17                	je     80462c <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  804615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804618:	89 c7                	mov    %eax,%edi
  80461a:	48 b8 aa 47 80 00 00 	movabs $0x8047aa,%rax
  804621:	00 00 00 
  804624:	ff d0                	callq  *%rax
  804626:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80462a:	89 02                	mov    %eax,(%rdx)
  return (1);
  80462c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804631:	c9                   	leaveq 
  804632:	c3                   	retq   

0000000000804633 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804633:	55                   	push   %rbp
  804634:	48 89 e5             	mov    %rsp,%rbp
  804637:	48 83 ec 30          	sub    $0x30,%rsp
  80463b:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80463e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804641:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804644:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80464b:	00 00 00 
  80464e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804652:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804656:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80465a:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  80465e:	e9 e0 00 00 00       	jmpq   804743 <inet_ntoa+0x110>
    i = 0;
  804663:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80466b:	0f b6 08             	movzbl (%rax),%ecx
  80466e:	0f b6 d1             	movzbl %cl,%edx
  804671:	89 d0                	mov    %edx,%eax
  804673:	c1 e0 02             	shl    $0x2,%eax
  804676:	01 d0                	add    %edx,%eax
  804678:	c1 e0 03             	shl    $0x3,%eax
  80467b:	01 d0                	add    %edx,%eax
  80467d:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804684:	01 d0                	add    %edx,%eax
  804686:	66 c1 e8 08          	shr    $0x8,%ax
  80468a:	c0 e8 03             	shr    $0x3,%al
  80468d:	88 45 ed             	mov    %al,-0x13(%rbp)
  804690:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804694:	89 d0                	mov    %edx,%eax
  804696:	c1 e0 02             	shl    $0x2,%eax
  804699:	01 d0                	add    %edx,%eax
  80469b:	01 c0                	add    %eax,%eax
  80469d:	29 c1                	sub    %eax,%ecx
  80469f:	89 c8                	mov    %ecx,%eax
  8046a1:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8046a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a8:	0f b6 00             	movzbl (%rax),%eax
  8046ab:	0f b6 d0             	movzbl %al,%edx
  8046ae:	89 d0                	mov    %edx,%eax
  8046b0:	c1 e0 02             	shl    $0x2,%eax
  8046b3:	01 d0                	add    %edx,%eax
  8046b5:	c1 e0 03             	shl    $0x3,%eax
  8046b8:	01 d0                	add    %edx,%eax
  8046ba:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8046c1:	01 d0                	add    %edx,%eax
  8046c3:	66 c1 e8 08          	shr    $0x8,%ax
  8046c7:	89 c2                	mov    %eax,%edx
  8046c9:	c0 ea 03             	shr    $0x3,%dl
  8046cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d0:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8046d2:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8046d6:	8d 50 01             	lea    0x1(%rax),%edx
  8046d9:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8046dc:	0f b6 c0             	movzbl %al,%eax
  8046df:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8046e3:	83 c2 30             	add    $0x30,%edx
  8046e6:	48 98                	cltq   
  8046e8:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  8046ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f0:	0f b6 00             	movzbl (%rax),%eax
  8046f3:	84 c0                	test   %al,%al
  8046f5:	0f 85 6c ff ff ff    	jne    804667 <inet_ntoa+0x34>
    while(i--)
  8046fb:	eb 1a                	jmp    804717 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8046fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804701:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804705:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804709:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  80470d:	48 63 d2             	movslq %edx,%rdx
  804710:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  804715:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  804717:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80471b:	8d 50 ff             	lea    -0x1(%rax),%edx
  80471e:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804721:	84 c0                	test   %al,%al
  804723:	75 d8                	jne    8046fd <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  804725:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804729:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80472d:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804731:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804734:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  804739:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80473d:	83 c0 01             	add    $0x1,%eax
  804740:	88 45 ef             	mov    %al,-0x11(%rbp)
  804743:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804747:	0f 86 16 ff ff ff    	jbe    804663 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  80474d:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804752:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804756:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804759:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804760:	00 00 00 
}
  804763:	c9                   	leaveq 
  804764:	c3                   	retq   

0000000000804765 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804765:	55                   	push   %rbp
  804766:	48 89 e5             	mov    %rsp,%rbp
  804769:	48 83 ec 04          	sub    $0x4,%rsp
  80476d:	89 f8                	mov    %edi,%eax
  80476f:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804773:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804777:	c1 e0 08             	shl    $0x8,%eax
  80477a:	89 c2                	mov    %eax,%edx
  80477c:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804780:	66 c1 e8 08          	shr    $0x8,%ax
  804784:	09 d0                	or     %edx,%eax
}
  804786:	c9                   	leaveq 
  804787:	c3                   	retq   

0000000000804788 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804788:	55                   	push   %rbp
  804789:	48 89 e5             	mov    %rsp,%rbp
  80478c:	48 83 ec 08          	sub    $0x8,%rsp
  804790:	89 f8                	mov    %edi,%eax
  804792:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804796:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80479a:	89 c7                	mov    %eax,%edi
  80479c:	48 b8 65 47 80 00 00 	movabs $0x804765,%rax
  8047a3:	00 00 00 
  8047a6:	ff d0                	callq  *%rax
}
  8047a8:	c9                   	leaveq 
  8047a9:	c3                   	retq   

00000000008047aa <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8047aa:	55                   	push   %rbp
  8047ab:	48 89 e5             	mov    %rsp,%rbp
  8047ae:	48 83 ec 04          	sub    $0x4,%rsp
  8047b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8047b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047b8:	c1 e0 18             	shl    $0x18,%eax
  8047bb:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8047bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047c0:	25 00 ff 00 00       	and    $0xff00,%eax
  8047c5:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8047c8:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8047ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047cd:	25 00 00 ff 00       	and    $0xff0000,%eax
  8047d2:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8047d6:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8047d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047db:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8047de:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8047e0:	c9                   	leaveq 
  8047e1:	c3                   	retq   

00000000008047e2 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8047e2:	55                   	push   %rbp
  8047e3:	48 89 e5             	mov    %rsp,%rbp
  8047e6:	48 83 ec 08          	sub    $0x8,%rsp
  8047ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8047ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f0:	89 c7                	mov    %eax,%edi
  8047f2:	48 b8 aa 47 80 00 00 	movabs $0x8047aa,%rax
  8047f9:	00 00 00 
  8047fc:	ff d0                	callq  *%rax
}
  8047fe:	c9                   	leaveq 
  8047ff:	c3                   	retq   
