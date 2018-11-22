
vmm/guest/obj/user/httpd:     file format elf64-x86-64


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
  80003c:	e8 f7 0a 00 00       	callq  800b38 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
	{404, "Not Found"},
};

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
  800056:	48 bf dc 55 80 00 00 	movabs $0x8055dc,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 bb 0b 80 00 00 	movabs $0x800bbb,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <req_free>:

static void
req_free(struct http_request *req)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 10          	sub    $0x10,%rsp
  800087:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	free(req->url);
  80008b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80008f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800093:	48 89 c7             	mov    %rax,%rdi
  800096:	48 b8 2e 43 80 00 00 	movabs $0x80432e,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	callq  *%rax
	free(req->version);
  8000a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000a6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8000aa:	48 89 c7             	mov    %rax,%rdi
  8000ad:	48 b8 2e 43 80 00 00 	movabs $0x80432e,%rax
  8000b4:	00 00 00 
  8000b7:	ff d0                	callq  *%rax
}
  8000b9:	c9                   	leaveq 
  8000ba:	c3                   	retq   

00000000008000bb <send_header>:

static int
send_header(struct http_request *req, int code)
{
  8000bb:	55                   	push   %rbp
  8000bc:	48 89 e5             	mov    %rsp,%rbp
  8000bf:	48 83 ec 20          	sub    $0x20,%rsp
  8000c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8000c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	struct responce_header *h = headers;
  8000ca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000d1:	00 00 00 
  8000d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000d8:	eb 12                	jmp    8000ec <send_header+0x31>
		if (h->code == code)
  8000da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000de:	8b 00                	mov    (%rax),%eax
  8000e0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8000e3:	75 02                	jne    8000e7 <send_header+0x2c>
			break;
  8000e5:	eb 1c                	jmp    800103 <send_header+0x48>
		h++;
  8000e7:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	8b 00                	mov    (%rax),%eax
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 0d                	je     800103 <send_header+0x48>
  8000f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8000fe:	48 85 c0             	test   %rax,%rax
  800101:	75 d7                	jne    8000da <send_header+0x1f>
		if (h->code == code)
			break;
		h++;
	}

	if (h->code == 0)
  800103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800107:	8b 00                	mov    (%rax),%eax
  800109:	85 c0                	test   %eax,%eax
  80010b:	75 07                	jne    800114 <send_header+0x59>
		return -1;
  80010d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800112:	eb 5f                	jmp    800173 <send_header+0xb8>

	int len = strlen(h->header);
  800114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800118:	48 8b 40 08          	mov    0x8(%rax),%rax
  80011c:	48 89 c7             	mov    %rax,%rdi
  80011f:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
  80012b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(req->sock, h->header, len) != len) {
  80012e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800131:	48 63 d0             	movslq %eax,%rdx
  800134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800138:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80013c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800140:	8b 00                	mov    (%rax),%eax
  800142:	48 89 ce             	mov    %rcx,%rsi
  800145:	89 c7                	mov    %eax,%edi
  800147:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  80014e:	00 00 00 
  800151:	ff d0                	callq  *%rax
  800153:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800156:	74 16                	je     80016e <send_header+0xb3>
		die("Failed to send bytes to client");
  800158:	48 bf e0 55 80 00 00 	movabs $0x8055e0,%rdi
  80015f:	00 00 00 
  800162:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800169:	00 00 00 
  80016c:	ff d0                	callq  *%rax
	}

	return 0;
  80016e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800173:	c9                   	leaveq 
  800174:	c3                   	retq   

0000000000800175 <send_data>:

static int
send_data(struct http_request *req, int fd)
{
  800175:	55                   	push   %rbp
  800176:	48 89 e5             	mov    %rsp,%rbp
  800179:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800180:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800187:	89 b5 e4 fe ff ff    	mov    %esi,-0x11c(%rbp)

	char buf[256];
	int n;

	for (;;) {
		n = read(fd, buf, sizeof(buf));
  80018d:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800194:	8b 85 e4 fe ff ff    	mov    -0x11c(%rbp),%eax
  80019a:	ba 00 01 00 00       	mov    $0x100,%edx
  80019f:	48 89 ce             	mov    %rcx,%rsi
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  8001ab:	00 00 00 
  8001ae:	ff d0                	callq  *%rax
  8001b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (n < 0) {
  8001b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b7:	79 25                	jns    8001de <send_data+0x69>
			cprintf("send_data: read failed: %e\n", n);
  8001b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001bc:	89 c6                	mov    %eax,%esi
  8001be:	48 bf ff 55 80 00 00 	movabs $0x8055ff,%rdi
  8001c5:	00 00 00 
  8001c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cd:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  8001d4:	00 00 00 
  8001d7:	ff d2                	callq  *%rdx
			return n;
  8001d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001dc:	eb 59                	jmp    800237 <send_data+0xc2>
		} else if (n == 0) {
  8001de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e2:	75 07                	jne    8001eb <send_data+0x76>
			return 0;
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	eb 4c                	jmp    800237 <send_data+0xc2>
		}

		if (write(req->sock, buf, n) != n)
  8001eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ee:	48 63 d0             	movslq %eax,%rdx
  8001f1:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  8001f8:	8b 00                	mov    (%rax),%eax
  8001fa:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800201:	48 89 ce             	mov    %rcx,%rsi
  800204:	89 c7                	mov    %eax,%edi
  800206:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800215:	74 1b                	je     800232 <send_data+0xbd>
			die("Failed to sent file to client");
  800217:	48 bf 1b 56 80 00 00 	movabs $0x80561b,%rdi
  80021e:	00 00 00 
  800221:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800228:	00 00 00 
  80022b:	ff d0                	callq  *%rax
	}
  80022d:	e9 5b ff ff ff       	jmpq   80018d <send_data+0x18>
  800232:	e9 56 ff ff ff       	jmpq   80018d <send_data+0x18>

}
  800237:	c9                   	leaveq 
  800238:	c3                   	retq   

0000000000800239 <send_size>:

static int
send_size(struct http_request *req, off_t size)
{
  800239:	55                   	push   %rbp
  80023a:	48 89 e5             	mov    %rsp,%rbp
  80023d:	48 83 ec 60          	sub    $0x60,%rsp
  800241:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800245:	89 75 a4             	mov    %esi,-0x5c(%rbp)
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  800248:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80024b:	48 63 d0             	movslq %eax,%rdx
  80024e:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800252:	48 89 d1             	mov    %rdx,%rcx
  800255:	48 ba 39 56 80 00 00 	movabs $0x805639,%rdx
  80025c:	00 00 00 
  80025f:	be 40 00 00 00       	mov    $0x40,%esi
  800264:	48 89 c7             	mov    %rax,%rdi
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b8 7f 18 80 00 00 	movabs $0x80187f,%r8
  800273:	00 00 00 
  800276:	41 ff d0             	callq  *%r8
  800279:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r > 63)
  80027c:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800280:	7e 2a                	jle    8002ac <send_size+0x73>
		panic("buffer too small!");
  800282:	48 ba 4f 56 80 00 00 	movabs $0x80564f,%rdx
  800289:	00 00 00 
  80028c:	be 6b 00 00 00       	mov    $0x6b,%esi
  800291:	48 bf 61 56 80 00 00 	movabs $0x805661,%rdi
  800298:	00 00 00 
  80029b:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a0:	48 b9 de 0b 80 00 00 	movabs $0x800bde,%rcx
  8002a7:	00 00 00 
  8002aa:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  8002ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002af:	48 63 d0             	movslq %eax,%rdx
  8002b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8002b6:	8b 00                	mov    (%rax),%eax
  8002b8:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  8002bc:	48 89 ce             	mov    %rcx,%rsi
  8002bf:	89 c7                	mov    %eax,%edi
  8002c1:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  8002c8:	00 00 00 
  8002cb:	ff d0                	callq  *%rax
  8002cd:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8002d0:	74 07                	je     8002d9 <send_size+0xa0>
		return -1;
  8002d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8002d7:	eb 05                	jmp    8002de <send_size+0xa5>

	return 0;
  8002d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002de:	c9                   	leaveq 
  8002df:	c3                   	retq   

00000000008002e0 <mime_type>:

static const char*
mime_type(const char *file)
{
  8002e0:	55                   	push   %rbp
  8002e1:	48 89 e5             	mov    %rsp,%rbp
  8002e4:	48 83 ec 08          	sub    $0x8,%rsp
  8002e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//TODO: for now only a single mime type
	return "text/html";
  8002ec:	48 b8 6e 56 80 00 00 	movabs $0x80566e,%rax
  8002f3:	00 00 00 
}
  8002f6:	c9                   	leaveq 
  8002f7:	c3                   	retq   

00000000008002f8 <send_content_type>:

static int
send_content_type(struct http_request *req)
{
  8002f8:	55                   	push   %rbp
  8002f9:	48 89 e5             	mov    %rsp,%rbp
  8002fc:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800303:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
	char buf[128];
	int r;
	const char *type;

	type = mime_type(req->url);
  80030a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800311:	48 8b 40 08          	mov    0x8(%rax),%rax
  800315:	48 89 c7             	mov    %rax,%rdi
  800318:	48 b8 e0 02 80 00 00 	movabs $0x8002e0,%rax
  80031f:	00 00 00 
  800322:	ff d0                	callq  *%rax
  800324:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!type)
  800328:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80032d:	75 0a                	jne    800339 <send_content_type+0x41>
		return -1;
  80032f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800334:	e9 9d 00 00 00       	jmpq   8003d6 <send_content_type+0xde>

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  800339:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80033d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800344:	48 89 d1             	mov    %rdx,%rcx
  800347:	48 ba 78 56 80 00 00 	movabs $0x805678,%rdx
  80034e:	00 00 00 
  800351:	be 80 00 00 00       	mov    $0x80,%esi
  800356:	48 89 c7             	mov    %rax,%rdi
  800359:	b8 00 00 00 00       	mov    $0x0,%eax
  80035e:	49 b8 7f 18 80 00 00 	movabs $0x80187f,%r8
  800365:	00 00 00 
  800368:	41 ff d0             	callq  *%r8
  80036b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (r > 127)
  80036e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  800372:	7e 2a                	jle    80039e <send_content_type+0xa6>
		panic("buffer too small!");
  800374:	48 ba 4f 56 80 00 00 	movabs $0x80564f,%rdx
  80037b:	00 00 00 
  80037e:	be 87 00 00 00       	mov    $0x87,%esi
  800383:	48 bf 61 56 80 00 00 	movabs $0x805661,%rdi
  80038a:	00 00 00 
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
  800392:	48 b9 de 0b 80 00 00 	movabs $0x800bde,%rcx
  800399:	00 00 00 
  80039c:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  80039e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003a1:	48 63 d0             	movslq %eax,%rdx
  8003a4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8003ab:	8b 00                	mov    (%rax),%eax
  8003ad:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8003b4:	48 89 ce             	mov    %rcx,%rsi
  8003b7:	89 c7                	mov    %eax,%edi
  8003b9:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  8003c0:	00 00 00 
  8003c3:	ff d0                	callq  *%rax
  8003c5:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8003c8:	74 07                	je     8003d1 <send_content_type+0xd9>
		return -1;
  8003ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003cf:	eb 05                	jmp    8003d6 <send_content_type+0xde>

	return 0;
  8003d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d6:	c9                   	leaveq 
  8003d7:	c3                   	retq   

00000000008003d8 <send_header_fin>:

static int
send_header_fin(struct http_request *req)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
  8003dc:	48 83 ec 20          	sub    $0x20,%rsp
  8003e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *fin = "\r\n";
  8003e4:	48 b8 8b 56 80 00 00 	movabs $0x80568b,%rax
  8003eb:	00 00 00 
  8003ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int fin_len = strlen(fin);
  8003f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f6:	48 89 c7             	mov    %rax,%rdi
  8003f9:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  800400:	00 00 00 
  800403:	ff d0                	callq  *%rax
  800405:	89 45 f4             	mov    %eax,-0xc(%rbp)

	if (write(req->sock, fin, fin_len) != fin_len)
  800408:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80040b:	48 63 d0             	movslq %eax,%rdx
  80040e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800412:	8b 00                	mov    (%rax),%eax
  800414:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800418:	48 89 ce             	mov    %rcx,%rsi
  80041b:	89 c7                	mov    %eax,%edi
  80041d:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  800424:	00 00 00 
  800427:	ff d0                	callq  *%rax
  800429:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80042c:	74 07                	je     800435 <send_header_fin+0x5d>
		return -1;
  80042e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800433:	eb 05                	jmp    80043a <send_header_fin+0x62>

	return 0;
  800435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80043a:	c9                   	leaveq 
  80043b:	c3                   	retq   

000000000080043c <http_request_parse>:

// given a request, this function creates a struct http_request
static int
http_request_parse(struct http_request *req, char *request)
{
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
  800440:	48 83 ec 30          	sub    $0x30,%rsp
  800444:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800448:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	const char *url;
	const char *version;
	int url_len, version_len;

	if (!req)
  80044c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800451:	75 0a                	jne    80045d <http_request_parse+0x21>
		return -1;
  800453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800458:	e9 57 01 00 00       	jmpq   8005b4 <http_request_parse+0x178>

	if (strncmp(request, "GET ", 4) != 0)
  80045d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800461:	ba 04 00 00 00       	mov    $0x4,%edx
  800466:	48 be 8e 56 80 00 00 	movabs $0x80568e,%rsi
  80046d:	00 00 00 
  800470:	48 89 c7             	mov    %rax,%rdi
  800473:	48 b8 81 1b 80 00 00 	movabs $0x801b81,%rax
  80047a:	00 00 00 
  80047d:	ff d0                	callq  *%rax
  80047f:	85 c0                	test   %eax,%eax
  800481:	74 0a                	je     80048d <http_request_parse+0x51>
		return -E_BAD_REQ;
  800483:	b8 18 fc ff ff       	mov    $0xfffffc18,%eax
  800488:	e9 27 01 00 00       	jmpq   8005b4 <http_request_parse+0x178>

	// skip GET
	request += 4;
  80048d:	48 83 45 d0 04       	addq   $0x4,-0x30(%rbp)

	// get the url
	url = request;
  800492:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800496:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (*request && *request != ' ')
  80049a:	eb 05                	jmp    8004a1 <http_request_parse+0x65>
		request++;
  80049c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  8004a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004a5:	0f b6 00             	movzbl (%rax),%eax
  8004a8:	84 c0                	test   %al,%al
  8004aa:	74 0b                	je     8004b7 <http_request_parse+0x7b>
  8004ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004b0:	0f b6 00             	movzbl (%rax),%eax
  8004b3:	3c 20                	cmp    $0x20,%al
  8004b5:	75 e5                	jne    80049c <http_request_parse+0x60>
		request++;
	url_len = request - url;
  8004b7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004bf:	48 29 c2             	sub    %rax,%rdx
  8004c2:	48 89 d0             	mov    %rdx,%rax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%rbp)

	req->url = malloc(url_len + 1);
  8004c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004cb:	83 c0 01             	add    $0x1,%eax
  8004ce:	48 98                	cltq   
  8004d0:	48 89 c7             	mov    %rax,%rdi
  8004d3:	48 b8 b0 3f 80 00 00 	movabs $0x803fb0,%rax
  8004da:	00 00 00 
  8004dd:	ff d0                	callq  *%rax
  8004df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004e3:	48 89 42 08          	mov    %rax,0x8(%rdx)
	memmove(req->url, url, url_len);
  8004e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004ea:	48 63 d0             	movslq %eax,%rdx
  8004ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004f5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004f9:	48 89 ce             	mov    %rcx,%rsi
  8004fc:	48 89 c7             	mov    %rax,%rdi
  8004ff:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  800506:	00 00 00 
  800509:	ff d0                	callq  *%rax
	req->url[url_len] = '\0';
  80050b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80050f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800513:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800516:	48 98                	cltq   
  800518:	48 01 d0             	add    %rdx,%rax
  80051b:	c6 00 00             	movb   $0x0,(%rax)

	// skip space
	request++;
  80051e:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	version = request;
  800523:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800527:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (*request && *request != '\n')
  80052b:	eb 05                	jmp    800532 <http_request_parse+0xf6>
		request++;
  80052d:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  800532:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800536:	0f b6 00             	movzbl (%rax),%eax
  800539:	84 c0                	test   %al,%al
  80053b:	74 0b                	je     800548 <http_request_parse+0x10c>
  80053d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800541:	0f b6 00             	movzbl (%rax),%eax
  800544:	3c 0a                	cmp    $0xa,%al
  800546:	75 e5                	jne    80052d <http_request_parse+0xf1>
		request++;
	version_len = request - version;
  800548:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80054c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800550:	48 29 c2             	sub    %rax,%rdx
  800553:	48 89 d0             	mov    %rdx,%rax
  800556:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	req->version = malloc(version_len + 1);
  800559:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80055c:	83 c0 01             	add    $0x1,%eax
  80055f:	48 98                	cltq   
  800561:	48 89 c7             	mov    %rax,%rdi
  800564:	48 b8 b0 3f 80 00 00 	movabs $0x803fb0,%rax
  80056b:	00 00 00 
  80056e:	ff d0                	callq  *%rax
  800570:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800574:	48 89 42 10          	mov    %rax,0x10(%rdx)
	memmove(req->version, version, version_len);
  800578:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80057b:	48 63 d0             	movslq %eax,%rdx
  80057e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800582:	48 8b 40 10          	mov    0x10(%rax),%rax
  800586:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80058a:	48 89 ce             	mov    %rcx,%rsi
  80058d:	48 89 c7             	mov    %rax,%rdi
  800590:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  800597:	00 00 00 
  80059a:	ff d0                	callq  *%rax
	req->version[version_len] = '\0';
  80059c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005a7:	48 98                	cltq   
  8005a9:	48 01 d0             	add    %rdx,%rax
  8005ac:	c6 00 00             	movb   $0x0,(%rax)

	// no entity parsing

	return 0;
  8005af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005b4:	c9                   	leaveq 
  8005b5:	c3                   	retq   

00000000008005b6 <send_error>:

static int
send_error(struct http_request *req, int code)
{
  8005b6:	55                   	push   %rbp
  8005b7:	48 89 e5             	mov    %rsp,%rbp
  8005ba:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
  8005c1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8005c8:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
	char buf[512];
	int r;

	struct error_messages *e = errors;
  8005ce:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8005d5:	00 00 00 
  8005d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  8005dc:	eb 15                	jmp    8005f3 <send_error+0x3d>
		if (e->code == code)
  8005de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e2:	8b 00                	mov    (%rax),%eax
  8005e4:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  8005ea:	75 02                	jne    8005ee <send_error+0x38>
			break;
  8005ec:	eb 1c                	jmp    80060a <send_error+0x54>
		e++;
  8005ee:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  8005f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005f7:	8b 00                	mov    (%rax),%eax
  8005f9:	85 c0                	test   %eax,%eax
  8005fb:	74 0d                	je     80060a <send_error+0x54>
  8005fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800601:	48 8b 40 08          	mov    0x8(%rax),%rax
  800605:	48 85 c0             	test   %rax,%rax
  800608:	75 d4                	jne    8005de <send_error+0x28>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	8b 00                	mov    (%rax),%eax
  800610:	85 c0                	test   %eax,%eax
  800612:	75 0a                	jne    80061e <send_error+0x68>
		return -1;
  800614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800619:	e9 8e 00 00 00       	jmpq   8006ac <send_error+0xf6>

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80061e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800622:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062a:	8b 38                	mov    (%rax),%edi
  80062c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800630:	48 8b 70 08          	mov    0x8(%rax),%rsi
  800634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800638:	8b 10                	mov    (%rax),%edx
  80063a:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800641:	48 89 0c 24          	mov    %rcx,(%rsp)
  800645:	41 89 f9             	mov    %edi,%r9d
  800648:	49 89 f0             	mov    %rsi,%r8
  80064b:	89 d1                	mov    %edx,%ecx
  80064d:	48 ba 98 56 80 00 00 	movabs $0x805698,%rdx
  800654:	00 00 00 
  800657:	be 00 02 00 00       	mov    $0x200,%esi
  80065c:	48 89 c7             	mov    %rax,%rdi
  80065f:	b8 00 00 00 00       	mov    $0x0,%eax
  800664:	49 ba 7f 18 80 00 00 	movabs $0x80187f,%r10
  80066b:	00 00 00 
  80066e:	41 ff d2             	callq  *%r10
  800671:	89 45 f4             	mov    %eax,-0xc(%rbp)
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  800674:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800677:	48 63 d0             	movslq %eax,%rdx
  80067a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  800681:	8b 00                	mov    (%rax),%eax
  800683:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80068a:	48 89 ce             	mov    %rcx,%rsi
  80068d:	89 c7                	mov    %eax,%edi
  80068f:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  800696:	00 00 00 
  800699:	ff d0                	callq  *%rax
  80069b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80069e:	74 07                	je     8006a7 <send_error+0xf1>
		return -1;
  8006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006a5:	eb 05                	jmp    8006ac <send_error+0xf6>

	return 0;
  8006a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ac:	c9                   	leaveq 
  8006ad:	c3                   	retq   

00000000008006ae <send_file>:

static int
send_file(struct http_request *req)
{
  8006ae:	55                   	push   %rbp
  8006af:	48 89 e5             	mov    %rsp,%rbp
  8006b2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8006b9:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
	int r;
	off_t file_size = -1;
  8006c0:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	// set file_size to the size of the file


	struct Stat stat;

	if ((fd = open(req->url, O_RDONLY)) < 0)
  8006c7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8006ce:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006d2:	be 00 00 00 00       	mov    $0x0,%esi
  8006d7:	48 89 c7             	mov    %rax,%rdi
  8006da:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  8006e1:	00 00 00 
  8006e4:	ff d0                	callq  *%rax
  8006e6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8006e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8006ed:	79 20                	jns    80070f <send_file+0x61>
		return send_error(req, 404);
  8006ef:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8006f6:	be 94 01 00 00       	mov    $0x194,%esi
  8006fb:	48 89 c7             	mov    %rax,%rdi
  8006fe:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  800705:	00 00 00 
  800708:	ff d0                	callq  *%rax
  80070a:	e9 56 01 00 00       	jmpq   800865 <send_file+0x1b7>

	if ((r = fstat(fd, &stat)) < 0) {
  80070f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800716:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800719:	48 89 d6             	mov    %rdx,%rsi
  80071c:	89 c7                	mov    %eax,%edi
  80071e:	48 b8 22 2f 80 00 00 	movabs $0x802f22,%rax
  800725:	00 00 00 
  800728:	ff d0                	callq  *%rax
  80072a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80072d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800731:	79 31                	jns    800764 <send_file+0xb6>
		close(fd);
  800733:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800736:	89 c7                	mov    %eax,%edi
  800738:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80073f:	00 00 00 
  800742:	ff d0                	callq  *%rax
		return send_error(req, 404);
  800744:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80074b:	be 94 01 00 00       	mov    $0x194,%esi
  800750:	48 89 c7             	mov    %rax,%rdi
  800753:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  80075a:	00 00 00 
  80075d:	ff d0                	callq  *%rax
  80075f:	e9 01 01 00 00       	jmpq   800865 <send_file+0x1b7>
	}

	if (stat.st_isdir) {
  800764:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800767:	85 c0                	test   %eax,%eax
  800769:	74 31                	je     80079c <send_file+0xee>
		close(fd);
  80076b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80076e:	89 c7                	mov    %eax,%edi
  800770:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  800777:	00 00 00 
  80077a:	ff d0                	callq  *%rax
		return send_error(req, 404);
  80077c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800783:	be 94 01 00 00       	mov    $0x194,%esi
  800788:	48 89 c7             	mov    %rax,%rdi
  80078b:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  800792:	00 00 00 
  800795:	ff d0                	callq  *%rax
  800797:	e9 c9 00 00 00       	jmpq   800865 <send_file+0x1b7>
	}

	file_size = stat.st_size;
  80079c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80079f:	89 45 f8             	mov    %eax,-0x8(%rbp)


	if ((r = send_header(req, 200)) < 0)
  8007a2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8007a9:	be c8 00 00 00       	mov    $0xc8,%esi
  8007ae:	48 89 c7             	mov    %rax,%rdi
  8007b1:	48 b8 bb 00 80 00 00 	movabs $0x8000bb,%rax
  8007b8:	00 00 00 
  8007bb:	ff d0                	callq  *%rax
  8007bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007c4:	79 05                	jns    8007cb <send_file+0x11d>
		goto end;
  8007c6:	e9 86 00 00 00       	jmpq   800851 <send_file+0x1a3>

	if ((r = send_size(req, file_size)) < 0)
  8007cb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8007ce:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8007d5:	89 d6                	mov    %edx,%esi
  8007d7:	48 89 c7             	mov    %rax,%rdi
  8007da:	48 b8 39 02 80 00 00 	movabs $0x800239,%rax
  8007e1:	00 00 00 
  8007e4:	ff d0                	callq  *%rax
  8007e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007ed:	79 02                	jns    8007f1 <send_file+0x143>
		goto end;
  8007ef:	eb 60                	jmp    800851 <send_file+0x1a3>

	if ((r = send_content_type(req)) < 0)
  8007f1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8007f8:	48 89 c7             	mov    %rax,%rdi
  8007fb:	48 b8 f8 02 80 00 00 	movabs $0x8002f8,%rax
  800802:	00 00 00 
  800805:	ff d0                	callq  *%rax
  800807:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80080a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80080e:	79 02                	jns    800812 <send_file+0x164>
		goto end;
  800810:	eb 3f                	jmp    800851 <send_file+0x1a3>

	if ((r = send_header_fin(req)) < 0)
  800812:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800819:	48 89 c7             	mov    %rax,%rdi
  80081c:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  800823:	00 00 00 
  800826:	ff d0                	callq  *%rax
  800828:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80082b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80082f:	79 02                	jns    800833 <send_file+0x185>
		goto end;
  800831:	eb 1e                	jmp    800851 <send_file+0x1a3>

	r = send_data(req, fd);
  800833:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800836:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80083d:	89 d6                	mov    %edx,%esi
  80083f:	48 89 c7             	mov    %rax,%rdi
  800842:	48 b8 75 01 80 00 00 	movabs $0x800175,%rax
  800849:	00 00 00 
  80084c:	ff d0                	callq  *%rax
  80084e:	89 45 fc             	mov    %eax,-0x4(%rbp)

end:
	close(fd);
  800851:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800854:	89 c7                	mov    %eax,%edi
  800856:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80085d:	00 00 00 
  800860:	ff d0                	callq  *%rax
	return r;
  800862:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800865:	c9                   	leaveq 
  800866:	c3                   	retq   

0000000000800867 <handle_client>:

static void
handle_client(int sock)
{
  800867:	55                   	push   %rbp
  800868:	48 89 e5             	mov    %rsp,%rbp
  80086b:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  800872:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
	struct http_request con_d;
	int r;
	char buffer[BUFFSIZE];
	int received = -1;
  800878:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	struct http_request *req = &con_d;
  80087f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800883:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800887:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  80088e:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  800894:	ba 00 02 00 00       	mov    $0x200,%edx
  800899:	48 89 ce             	mov    %rcx,%rsi
  80089c:	89 c7                	mov    %eax,%edi
  80089e:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  8008a5:	00 00 00 
  8008a8:	ff d0                	callq  *%rax
  8008aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008b1:	79 2a                	jns    8008dd <handle_client+0x76>
			panic("failed to read");
  8008b3:	48 ba 13 57 80 00 00 	movabs $0x805713,%rdx
  8008ba:	00 00 00 
  8008bd:	be 24 01 00 00       	mov    $0x124,%esi
  8008c2:	48 bf 61 56 80 00 00 	movabs $0x805661,%rdi
  8008c9:	00 00 00 
  8008cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d1:	48 b9 de 0b 80 00 00 	movabs $0x800bde,%rcx
  8008d8:	00 00 00 
  8008db:	ff d1                	callq  *%rcx

		memset(req, 0, sizeof(req));
  8008dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008e1:	ba 08 00 00 00       	mov    $0x8,%edx
  8008e6:	be 00 00 00 00       	mov    $0x0,%esi
  8008eb:	48 89 c7             	mov    %rax,%rdi
  8008ee:	48 b8 65 1c 80 00 00 	movabs $0x801c65,%rax
  8008f5:	00 00 00 
  8008f8:	ff d0                	callq  *%rax

		req->sock = sock;
  8008fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008fe:	8b 95 cc fd ff ff    	mov    -0x234(%rbp),%edx
  800904:	89 10                	mov    %edx,(%rax)

		r = http_request_parse(req, buffer);
  800906:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80090d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800911:	48 89 d6             	mov    %rdx,%rsi
  800914:	48 89 c7             	mov    %rax,%rdi
  800917:	48 b8 3c 04 80 00 00 	movabs $0x80043c,%rax
  80091e:	00 00 00 
  800921:	ff d0                	callq  *%rax
  800923:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r == -E_BAD_REQ)
  800926:	81 7d ec 18 fc ff ff 	cmpl   $0xfffffc18,-0x14(%rbp)
  80092d:	75 1a                	jne    800949 <handle_client+0xe2>
			send_error(req, 400);
  80092f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800933:	be 90 01 00 00       	mov    $0x190,%esi
  800938:	48 89 c7             	mov    %rax,%rdi
  80093b:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  800942:	00 00 00 
  800945:	ff d0                	callq  *%rax
  800947:	eb 43                	jmp    80098c <handle_client+0x125>
		else if (r < 0)
  800949:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80094d:	79 2a                	jns    800979 <handle_client+0x112>
			panic("parse failed");
  80094f:	48 ba 22 57 80 00 00 	movabs $0x805722,%rdx
  800956:	00 00 00 
  800959:	be 2e 01 00 00       	mov    $0x12e,%esi
  80095e:	48 bf 61 56 80 00 00 	movabs $0x805661,%rdi
  800965:	00 00 00 
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
  80096d:	48 b9 de 0b 80 00 00 	movabs $0x800bde,%rcx
  800974:	00 00 00 
  800977:	ff d1                	callq  *%rcx
		else
			send_file(req);
  800979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80097d:	48 89 c7             	mov    %rax,%rdi
  800980:	48 b8 ae 06 80 00 00 	movabs $0x8006ae,%rax
  800987:	00 00 00 
  80098a:	ff d0                	callq  *%rax

		req_free(req);
  80098c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800990:	48 89 c7             	mov    %rax,%rdi
  800993:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  80099a:	00 00 00 
  80099d:	ff d0                	callq  *%rax

		// no keep alive
		break;
  80099f:	90                   	nop
	}

	close(sock);
  8009a0:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8009a6:	89 c7                	mov    %eax,%edi
  8009a8:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8009af:	00 00 00 
  8009b2:	ff d0                	callq  *%rax
}
  8009b4:	c9                   	leaveq 
  8009b5:	c3                   	retq   

00000000008009b6 <umain>:

void
umain(int argc, char **argv)
{
  8009b6:	55                   	push   %rbp
  8009b7:	48 89 e5             	mov    %rsp,%rbp
  8009ba:	53                   	push   %rbx
  8009bb:	48 83 ec 58          	sub    $0x58,%rsp
  8009bf:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8009c2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8009c6:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8009cd:	00 00 00 
  8009d0:	48 bb 2f 57 80 00 00 	movabs $0x80572f,%rbx
  8009d7:	00 00 00 
  8009da:	48 89 18             	mov    %rbx,(%rax)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8009dd:	ba 06 00 00 00       	mov    $0x6,%edx
  8009e2:	be 01 00 00 00       	mov    $0x1,%esi
  8009e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8009ec:	48 b8 7b 3a 80 00 00 	movabs $0x803a7b,%rax
  8009f3:	00 00 00 
  8009f6:	ff d0                	callq  *%rax
  8009f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8009fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8009ff:	79 16                	jns    800a17 <umain+0x61>
		die("Failed to create socket");
  800a01:	48 bf 36 57 80 00 00 	movabs $0x805736,%rdi
  800a08:	00 00 00 
  800a0b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a12:	00 00 00 
  800a15:	ff d0                	callq  *%rax

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800a17:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800a1b:	ba 10 00 00 00       	mov    $0x10,%edx
  800a20:	be 00 00 00 00       	mov    $0x0,%esi
  800a25:	48 89 c7             	mov    %rax,%rdi
  800a28:	48 b8 65 1c 80 00 00 	movabs $0x801c65,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
	server.sin_family = AF_INET;			// Internet/IP
  800a34:	c6 45 d1 02          	movb   $0x2,-0x2f(%rbp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800a38:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3d:	48 b8 34 55 80 00 00 	movabs $0x805534,%rax
  800a44:	00 00 00 
  800a47:	ff d0                	callq  *%rax
  800a49:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	server.sin_port = htons(PORT);			// server port
  800a4c:	bf 50 00 00 00       	mov    $0x50,%edi
  800a51:	48 b8 ef 54 80 00 00 	movabs $0x8054ef,%rax
  800a58:	00 00 00 
  800a5b:	ff d0                	callq  *%rax
  800a5d:	66 89 45 d2          	mov    %ax,-0x2e(%rbp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800a61:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800a65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800a68:	ba 10 00 00 00       	mov    $0x10,%edx
  800a6d:	48 89 ce             	mov    %rcx,%rsi
  800a70:	89 c7                	mov    %eax,%edi
  800a72:	48 b8 6b 38 80 00 00 	movabs $0x80386b,%rax
  800a79:	00 00 00 
  800a7c:	ff d0                	callq  *%rax
  800a7e:	85 c0                	test   %eax,%eax
  800a80:	79 16                	jns    800a98 <umain+0xe2>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800a82:	48 bf 50 57 80 00 00 	movabs $0x805750,%rdi
  800a89:	00 00 00 
  800a8c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a93:	00 00 00 
  800a96:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800a98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800a9b:	be 05 00 00 00       	mov    $0x5,%esi
  800aa0:	89 c7                	mov    %eax,%edi
  800aa2:	48 b8 8e 39 80 00 00 	movabs $0x80398e,%rax
  800aa9:	00 00 00 
  800aac:	ff d0                	callq  *%rax
  800aae:	85 c0                	test   %eax,%eax
  800ab0:	79 16                	jns    800ac8 <umain+0x112>
		die("Failed to listen on server socket");
  800ab2:	48 bf 78 57 80 00 00 	movabs $0x805778,%rdi
  800ab9:	00 00 00 
  800abc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800ac3:	00 00 00 
  800ac6:	ff d0                	callq  *%rax

	cprintf("Waiting for http connections...\n");
  800ac8:	48 bf a0 57 80 00 00 	movabs $0x8057a0,%rdi
  800acf:	00 00 00 
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  800ade:	00 00 00 
  800ae1:	ff d2                	callq  *%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
  800ae3:	c7 45 bc 10 00 00 00 	movl   $0x10,-0x44(%rbp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800aea:	48 8d 55 bc          	lea    -0x44(%rbp),%rdx
  800aee:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800af2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800af5:	48 89 ce             	mov    %rcx,%rsi
  800af8:	89 c7                	mov    %eax,%edi
  800afa:	48 b8 fc 37 80 00 00 	movabs $0x8037fc,%rax
  800b01:	00 00 00 
  800b04:	ff d0                	callq  *%rax
  800b06:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800b09:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800b0d:	79 16                	jns    800b25 <umain+0x16f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800b0f:	48 bf c8 57 80 00 00 	movabs $0x8057c8,%rdi
  800b16:	00 00 00 
  800b19:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800b20:	00 00 00 
  800b23:	ff d0                	callq  *%rax
		}
		handle_client(clientsock);
  800b25:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800b28:	89 c7                	mov    %eax,%edi
  800b2a:	48 b8 67 08 80 00 00 	movabs $0x800867,%rax
  800b31:	00 00 00 
  800b34:	ff d0                	callq  *%rax
	}
  800b36:	eb ab                	jmp    800ae3 <umain+0x12d>

0000000000800b38 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800b38:	55                   	push   %rbp
  800b39:	48 89 e5             	mov    %rsp,%rbp
  800b3c:	48 83 ec 10          	sub    $0x10,%rsp
  800b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800b47:	48 b8 7f 22 80 00 00 	movabs $0x80227f,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	callq  *%rax
  800b53:	25 ff 03 00 00       	and    $0x3ff,%eax
  800b58:	48 98                	cltq   
  800b5a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800b61:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800b68:	00 00 00 
  800b6b:	48 01 c2             	add    %rax,%rdx
  800b6e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800b75:	00 00 00 
  800b78:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b7f:	7e 14                	jle    800b95 <libmain+0x5d>
		binaryname = argv[0];
  800b81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b85:	48 8b 10             	mov    (%rax),%rdx
  800b88:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  800b8f:	00 00 00 
  800b92:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800b95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b9c:	48 89 d6             	mov    %rdx,%rsi
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	48 b8 b6 09 80 00 00 	movabs $0x8009b6,%rax
  800ba8:	00 00 00 
  800bab:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800bad:	48 b8 bb 0b 80 00 00 	movabs $0x800bbb,%rax
  800bb4:	00 00 00 
  800bb7:	ff d0                	callq  *%rax
}
  800bb9:	c9                   	leaveq 
  800bba:	c3                   	retq   

0000000000800bbb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800bbb:	55                   	push   %rbp
  800bbc:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800bbf:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  800bc6:	00 00 00 
  800bc9:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800bcb:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd0:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  800bd7:	00 00 00 
  800bda:	ff d0                	callq  *%rax
}
  800bdc:	5d                   	pop    %rbp
  800bdd:	c3                   	retq   

0000000000800bde <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800bde:	55                   	push   %rbp
  800bdf:	48 89 e5             	mov    %rsp,%rbp
  800be2:	53                   	push   %rbx
  800be3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800bea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800bf1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800bf7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800bfe:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800c05:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800c0c:	84 c0                	test   %al,%al
  800c0e:	74 23                	je     800c33 <_panic+0x55>
  800c10:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800c17:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800c1b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800c1f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800c23:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800c27:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800c2b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800c2f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800c33:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c3a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800c41:	00 00 00 
  800c44:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800c4b:	00 00 00 
  800c4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c52:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800c59:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800c60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c67:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  800c6e:	00 00 00 
  800c71:	48 8b 18             	mov    (%rax),%rbx
  800c74:	48 b8 7f 22 80 00 00 	movabs $0x80227f,%rax
  800c7b:	00 00 00 
  800c7e:	ff d0                	callq  *%rax
  800c80:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800c86:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c8d:	41 89 c8             	mov    %ecx,%r8d
  800c90:	48 89 d1             	mov    %rdx,%rcx
  800c93:	48 89 da             	mov    %rbx,%rdx
  800c96:	89 c6                	mov    %eax,%esi
  800c98:	48 bf f8 57 80 00 00 	movabs $0x8057f8,%rdi
  800c9f:	00 00 00 
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca7:	49 b9 17 0e 80 00 00 	movabs $0x800e17,%r9
  800cae:	00 00 00 
  800cb1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800cb4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800cbb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800cc2:	48 89 d6             	mov    %rdx,%rsi
  800cc5:	48 89 c7             	mov    %rax,%rdi
  800cc8:	48 b8 6b 0d 80 00 00 	movabs $0x800d6b,%rax
  800ccf:	00 00 00 
  800cd2:	ff d0                	callq  *%rax
	cprintf("\n");
  800cd4:	48 bf 1b 58 80 00 00 	movabs $0x80581b,%rdi
  800cdb:	00 00 00 
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce3:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  800cea:	00 00 00 
  800ced:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800cef:	cc                   	int3   
  800cf0:	eb fd                	jmp    800cef <_panic+0x111>

0000000000800cf2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800cf2:	55                   	push   %rbp
  800cf3:	48 89 e5             	mov    %rsp,%rbp
  800cf6:	48 83 ec 10          	sub    $0x10,%rsp
  800cfa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d05:	8b 00                	mov    (%rax),%eax
  800d07:	8d 48 01             	lea    0x1(%rax),%ecx
  800d0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d0e:	89 0a                	mov    %ecx,(%rdx)
  800d10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d13:	89 d1                	mov    %edx,%ecx
  800d15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d19:	48 98                	cltq   
  800d1b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d23:	8b 00                	mov    (%rax),%eax
  800d25:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d2a:	75 2c                	jne    800d58 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d30:	8b 00                	mov    (%rax),%eax
  800d32:	48 98                	cltq   
  800d34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d38:	48 83 c2 08          	add    $0x8,%rdx
  800d3c:	48 89 c6             	mov    %rax,%rsi
  800d3f:	48 89 d7             	mov    %rdx,%rdi
  800d42:	48 b8 b3 21 80 00 00 	movabs $0x8021b3,%rax
  800d49:	00 00 00 
  800d4c:	ff d0                	callq  *%rax
        b->idx = 0;
  800d4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d52:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5c:	8b 40 04             	mov    0x4(%rax),%eax
  800d5f:	8d 50 01             	lea    0x1(%rax),%edx
  800d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d66:	89 50 04             	mov    %edx,0x4(%rax)
}
  800d69:	c9                   	leaveq 
  800d6a:	c3                   	retq   

0000000000800d6b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800d6b:	55                   	push   %rbp
  800d6c:	48 89 e5             	mov    %rsp,%rbp
  800d6f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800d76:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800d7d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800d84:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800d8b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800d92:	48 8b 0a             	mov    (%rdx),%rcx
  800d95:	48 89 08             	mov    %rcx,(%rax)
  800d98:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d9c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800da0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800da4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800da8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800daf:	00 00 00 
    b.cnt = 0;
  800db2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800db9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800dbc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800dc3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800dca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800dd1:	48 89 c6             	mov    %rax,%rsi
  800dd4:	48 bf f2 0c 80 00 00 	movabs $0x800cf2,%rdi
  800ddb:	00 00 00 
  800dde:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  800de5:	00 00 00 
  800de8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800dea:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800df0:	48 98                	cltq   
  800df2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800df9:	48 83 c2 08          	add    $0x8,%rdx
  800dfd:	48 89 c6             	mov    %rax,%rsi
  800e00:	48 89 d7             	mov    %rdx,%rdi
  800e03:	48 b8 b3 21 80 00 00 	movabs $0x8021b3,%rax
  800e0a:	00 00 00 
  800e0d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800e0f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800e15:	c9                   	leaveq 
  800e16:	c3                   	retq   

0000000000800e17 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800e17:	55                   	push   %rbp
  800e18:	48 89 e5             	mov    %rsp,%rbp
  800e1b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800e22:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800e29:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800e30:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e37:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e3e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e45:	84 c0                	test   %al,%al
  800e47:	74 20                	je     800e69 <cprintf+0x52>
  800e49:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e4d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e51:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e55:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e59:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e5d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e61:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e65:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e69:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800e70:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800e77:	00 00 00 
  800e7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e81:	00 00 00 
  800e84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800e9d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ea4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800eab:	48 8b 0a             	mov    (%rdx),%rcx
  800eae:	48 89 08             	mov    %rcx,(%rax)
  800eb1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eb9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ebd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800ec1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800ec8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ecf:	48 89 d6             	mov    %rdx,%rsi
  800ed2:	48 89 c7             	mov    %rax,%rdi
  800ed5:	48 b8 6b 0d 80 00 00 	movabs $0x800d6b,%rax
  800edc:	00 00 00 
  800edf:	ff d0                	callq  *%rax
  800ee1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800ee7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800eed:	c9                   	leaveq 
  800eee:	c3                   	retq   

0000000000800eef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800eef:	55                   	push   %rbp
  800ef0:	48 89 e5             	mov    %rsp,%rbp
  800ef3:	53                   	push   %rbx
  800ef4:	48 83 ec 38          	sub    $0x38,%rsp
  800ef8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800f04:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800f07:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800f0b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f0f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800f12:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f16:	77 3b                	ja     800f53 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f18:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800f1b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800f1f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800f22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f26:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2b:	48 f7 f3             	div    %rbx
  800f2e:	48 89 c2             	mov    %rax,%rdx
  800f31:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800f34:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800f37:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3f:	41 89 f9             	mov    %edi,%r9d
  800f42:	48 89 c7             	mov    %rax,%rdi
  800f45:	48 b8 ef 0e 80 00 00 	movabs $0x800eef,%rax
  800f4c:	00 00 00 
  800f4f:	ff d0                	callq  *%rax
  800f51:	eb 1e                	jmp    800f71 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800f53:	eb 12                	jmp    800f67 <printnum+0x78>
			putch(padc, putdat);
  800f55:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800f59:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f60:	48 89 ce             	mov    %rcx,%rsi
  800f63:	89 d7                	mov    %edx,%edi
  800f65:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800f67:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800f6b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800f6f:	7f e4                	jg     800f55 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800f71:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800f74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f78:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7d:	48 f7 f1             	div    %rcx
  800f80:	48 89 d0             	mov    %rdx,%rax
  800f83:	48 ba 10 5a 80 00 00 	movabs $0x805a10,%rdx
  800f8a:	00 00 00 
  800f8d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800f91:	0f be d0             	movsbl %al,%edx
  800f94:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 89 ce             	mov    %rcx,%rsi
  800f9f:	89 d7                	mov    %edx,%edi
  800fa1:	ff d0                	callq  *%rax
}
  800fa3:	48 83 c4 38          	add    $0x38,%rsp
  800fa7:	5b                   	pop    %rbx
  800fa8:	5d                   	pop    %rbp
  800fa9:	c3                   	retq   

0000000000800faa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800faa:	55                   	push   %rbp
  800fab:	48 89 e5             	mov    %rsp,%rbp
  800fae:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fb6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800fb9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fbd:	7e 52                	jle    801011 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800fbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc3:	8b 00                	mov    (%rax),%eax
  800fc5:	83 f8 30             	cmp    $0x30,%eax
  800fc8:	73 24                	jae    800fee <getuint+0x44>
  800fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd6:	8b 00                	mov    (%rax),%eax
  800fd8:	89 c0                	mov    %eax,%eax
  800fda:	48 01 d0             	add    %rdx,%rax
  800fdd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fe1:	8b 12                	mov    (%rdx),%edx
  800fe3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fe6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fea:	89 0a                	mov    %ecx,(%rdx)
  800fec:	eb 17                	jmp    801005 <getuint+0x5b>
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ff6:	48 89 d0             	mov    %rdx,%rax
  800ff9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ffd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801001:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801005:	48 8b 00             	mov    (%rax),%rax
  801008:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80100c:	e9 a3 00 00 00       	jmpq   8010b4 <getuint+0x10a>
	else if (lflag)
  801011:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801015:	74 4f                	je     801066 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801017:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101b:	8b 00                	mov    (%rax),%eax
  80101d:	83 f8 30             	cmp    $0x30,%eax
  801020:	73 24                	jae    801046 <getuint+0x9c>
  801022:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801026:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80102a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102e:	8b 00                	mov    (%rax),%eax
  801030:	89 c0                	mov    %eax,%eax
  801032:	48 01 d0             	add    %rdx,%rax
  801035:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801039:	8b 12                	mov    (%rdx),%edx
  80103b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80103e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801042:	89 0a                	mov    %ecx,(%rdx)
  801044:	eb 17                	jmp    80105d <getuint+0xb3>
  801046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80104e:	48 89 d0             	mov    %rdx,%rax
  801051:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801055:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801059:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80105d:	48 8b 00             	mov    (%rax),%rax
  801060:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801064:	eb 4e                	jmp    8010b4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  801066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106a:	8b 00                	mov    (%rax),%eax
  80106c:	83 f8 30             	cmp    $0x30,%eax
  80106f:	73 24                	jae    801095 <getuint+0xeb>
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107d:	8b 00                	mov    (%rax),%eax
  80107f:	89 c0                	mov    %eax,%eax
  801081:	48 01 d0             	add    %rdx,%rax
  801084:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801088:	8b 12                	mov    (%rdx),%edx
  80108a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80108d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801091:	89 0a                	mov    %ecx,(%rdx)
  801093:	eb 17                	jmp    8010ac <getuint+0x102>
  801095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801099:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80109d:	48 89 d0             	mov    %rdx,%rax
  8010a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010ac:	8b 00                	mov    (%rax),%eax
  8010ae:	89 c0                	mov    %eax,%eax
  8010b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b8:	c9                   	leaveq 
  8010b9:	c3                   	retq   

00000000008010ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010ba:	55                   	push   %rbp
  8010bb:	48 89 e5             	mov    %rsp,%rbp
  8010be:	48 83 ec 1c          	sub    $0x1c,%rsp
  8010c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8010c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010cd:	7e 52                	jle    801121 <getint+0x67>
		x=va_arg(*ap, long long);
  8010cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d3:	8b 00                	mov    (%rax),%eax
  8010d5:	83 f8 30             	cmp    $0x30,%eax
  8010d8:	73 24                	jae    8010fe <getint+0x44>
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e6:	8b 00                	mov    (%rax),%eax
  8010e8:	89 c0                	mov    %eax,%eax
  8010ea:	48 01 d0             	add    %rdx,%rax
  8010ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010f1:	8b 12                	mov    (%rdx),%edx
  8010f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010fa:	89 0a                	mov    %ecx,(%rdx)
  8010fc:	eb 17                	jmp    801115 <getint+0x5b>
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801106:	48 89 d0             	mov    %rdx,%rax
  801109:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80110d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801111:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801115:	48 8b 00             	mov    (%rax),%rax
  801118:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80111c:	e9 a3 00 00 00       	jmpq   8011c4 <getint+0x10a>
	else if (lflag)
  801121:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801125:	74 4f                	je     801176 <getint+0xbc>
		x=va_arg(*ap, long);
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	8b 00                	mov    (%rax),%eax
  80112d:	83 f8 30             	cmp    $0x30,%eax
  801130:	73 24                	jae    801156 <getint+0x9c>
  801132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801136:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80113a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113e:	8b 00                	mov    (%rax),%eax
  801140:	89 c0                	mov    %eax,%eax
  801142:	48 01 d0             	add    %rdx,%rax
  801145:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801149:	8b 12                	mov    (%rdx),%edx
  80114b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80114e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801152:	89 0a                	mov    %ecx,(%rdx)
  801154:	eb 17                	jmp    80116d <getint+0xb3>
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80115e:	48 89 d0             	mov    %rdx,%rax
  801161:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801165:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801169:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80116d:	48 8b 00             	mov    (%rax),%rax
  801170:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801174:	eb 4e                	jmp    8011c4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  801176:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117a:	8b 00                	mov    (%rax),%eax
  80117c:	83 f8 30             	cmp    $0x30,%eax
  80117f:	73 24                	jae    8011a5 <getint+0xeb>
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	8b 00                	mov    (%rax),%eax
  80118f:	89 c0                	mov    %eax,%eax
  801191:	48 01 d0             	add    %rdx,%rax
  801194:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801198:	8b 12                	mov    (%rdx),%edx
  80119a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80119d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a1:	89 0a                	mov    %ecx,(%rdx)
  8011a3:	eb 17                	jmp    8011bc <getint+0x102>
  8011a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011ad:	48 89 d0             	mov    %rdx,%rax
  8011b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011bc:	8b 00                	mov    (%rax),%eax
  8011be:	48 98                	cltq   
  8011c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c8:	c9                   	leaveq 
  8011c9:	c3                   	retq   

00000000008011ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	41 54                	push   %r12
  8011d0:	53                   	push   %rbx
  8011d1:	48 83 ec 60          	sub    $0x60,%rsp
  8011d5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8011d9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8011dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8011e1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8011e5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011e9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8011ed:	48 8b 0a             	mov    (%rdx),%rcx
  8011f0:	48 89 08             	mov    %rcx,(%rax)
  8011f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801203:	eb 17                	jmp    80121c <vprintfmt+0x52>
			if (ch == '\0')
  801205:	85 db                	test   %ebx,%ebx
  801207:	0f 84 cc 04 00 00    	je     8016d9 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80120d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801211:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801215:	48 89 d6             	mov    %rdx,%rsi
  801218:	89 df                	mov    %ebx,%edi
  80121a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80121c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801220:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801224:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801228:	0f b6 00             	movzbl (%rax),%eax
  80122b:	0f b6 d8             	movzbl %al,%ebx
  80122e:	83 fb 25             	cmp    $0x25,%ebx
  801231:	75 d2                	jne    801205 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801233:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801237:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80123e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801245:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80124c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801253:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801257:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80125b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	0f b6 d8             	movzbl %al,%ebx
  801265:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801268:	83 f8 55             	cmp    $0x55,%eax
  80126b:	0f 87 34 04 00 00    	ja     8016a5 <vprintfmt+0x4db>
  801271:	89 c0                	mov    %eax,%eax
  801273:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80127a:	00 
  80127b:	48 b8 38 5a 80 00 00 	movabs $0x805a38,%rax
  801282:	00 00 00 
  801285:	48 01 d0             	add    %rdx,%rax
  801288:	48 8b 00             	mov    (%rax),%rax
  80128b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80128d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801291:	eb c0                	jmp    801253 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801293:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801297:	eb ba                	jmp    801253 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801299:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8012a0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	c1 e0 02             	shl    $0x2,%eax
  8012a8:	01 d0                	add    %edx,%eax
  8012aa:	01 c0                	add    %eax,%eax
  8012ac:	01 d8                	add    %ebx,%eax
  8012ae:	83 e8 30             	sub    $0x30,%eax
  8012b1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8012b4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8012be:	83 fb 2f             	cmp    $0x2f,%ebx
  8012c1:	7e 0c                	jle    8012cf <vprintfmt+0x105>
  8012c3:	83 fb 39             	cmp    $0x39,%ebx
  8012c6:	7f 07                	jg     8012cf <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012c8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012cd:	eb d1                	jmp    8012a0 <vprintfmt+0xd6>
			goto process_precision;
  8012cf:	eb 58                	jmp    801329 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8012d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012d4:	83 f8 30             	cmp    $0x30,%eax
  8012d7:	73 17                	jae    8012f0 <vprintfmt+0x126>
  8012d9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012e0:	89 c0                	mov    %eax,%eax
  8012e2:	48 01 d0             	add    %rdx,%rax
  8012e5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012e8:	83 c2 08             	add    $0x8,%edx
  8012eb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012ee:	eb 0f                	jmp    8012ff <vprintfmt+0x135>
  8012f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012f4:	48 89 d0             	mov    %rdx,%rax
  8012f7:	48 83 c2 08          	add    $0x8,%rdx
  8012fb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012ff:	8b 00                	mov    (%rax),%eax
  801301:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801304:	eb 23                	jmp    801329 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801306:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80130a:	79 0c                	jns    801318 <vprintfmt+0x14e>
				width = 0;
  80130c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801313:	e9 3b ff ff ff       	jmpq   801253 <vprintfmt+0x89>
  801318:	e9 36 ff ff ff       	jmpq   801253 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80131d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801324:	e9 2a ff ff ff       	jmpq   801253 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801329:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80132d:	79 12                	jns    801341 <vprintfmt+0x177>
				width = precision, precision = -1;
  80132f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801332:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80133c:	e9 12 ff ff ff       	jmpq   801253 <vprintfmt+0x89>
  801341:	e9 0d ff ff ff       	jmpq   801253 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801346:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80134a:	e9 04 ff ff ff       	jmpq   801253 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80134f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801352:	83 f8 30             	cmp    $0x30,%eax
  801355:	73 17                	jae    80136e <vprintfmt+0x1a4>
  801357:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80135b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80135e:	89 c0                	mov    %eax,%eax
  801360:	48 01 d0             	add    %rdx,%rax
  801363:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801366:	83 c2 08             	add    $0x8,%edx
  801369:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80136c:	eb 0f                	jmp    80137d <vprintfmt+0x1b3>
  80136e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801372:	48 89 d0             	mov    %rdx,%rax
  801375:	48 83 c2 08          	add    $0x8,%rdx
  801379:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80137d:	8b 10                	mov    (%rax),%edx
  80137f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801383:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801387:	48 89 ce             	mov    %rcx,%rsi
  80138a:	89 d7                	mov    %edx,%edi
  80138c:	ff d0                	callq  *%rax
			break;
  80138e:	e9 40 03 00 00       	jmpq   8016d3 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801393:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801396:	83 f8 30             	cmp    $0x30,%eax
  801399:	73 17                	jae    8013b2 <vprintfmt+0x1e8>
  80139b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80139f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013a2:	89 c0                	mov    %eax,%eax
  8013a4:	48 01 d0             	add    %rdx,%rax
  8013a7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013aa:	83 c2 08             	add    $0x8,%edx
  8013ad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013b0:	eb 0f                	jmp    8013c1 <vprintfmt+0x1f7>
  8013b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013b6:	48 89 d0             	mov    %rdx,%rax
  8013b9:	48 83 c2 08          	add    $0x8,%rdx
  8013bd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013c1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8013c3:	85 db                	test   %ebx,%ebx
  8013c5:	79 02                	jns    8013c9 <vprintfmt+0x1ff>
				err = -err;
  8013c7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013c9:	83 fb 15             	cmp    $0x15,%ebx
  8013cc:	7f 16                	jg     8013e4 <vprintfmt+0x21a>
  8013ce:	48 b8 60 59 80 00 00 	movabs $0x805960,%rax
  8013d5:	00 00 00 
  8013d8:	48 63 d3             	movslq %ebx,%rdx
  8013db:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8013df:	4d 85 e4             	test   %r12,%r12
  8013e2:	75 2e                	jne    801412 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8013e4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ec:	89 d9                	mov    %ebx,%ecx
  8013ee:	48 ba 21 5a 80 00 00 	movabs $0x805a21,%rdx
  8013f5:	00 00 00 
  8013f8:	48 89 c7             	mov    %rax,%rdi
  8013fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801400:	49 b8 e2 16 80 00 00 	movabs $0x8016e2,%r8
  801407:	00 00 00 
  80140a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80140d:	e9 c1 02 00 00       	jmpq   8016d3 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801412:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801416:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80141a:	4c 89 e1             	mov    %r12,%rcx
  80141d:	48 ba 2a 5a 80 00 00 	movabs $0x805a2a,%rdx
  801424:	00 00 00 
  801427:	48 89 c7             	mov    %rax,%rdi
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
  80142f:	49 b8 e2 16 80 00 00 	movabs $0x8016e2,%r8
  801436:	00 00 00 
  801439:	41 ff d0             	callq  *%r8
			break;
  80143c:	e9 92 02 00 00       	jmpq   8016d3 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801441:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801444:	83 f8 30             	cmp    $0x30,%eax
  801447:	73 17                	jae    801460 <vprintfmt+0x296>
  801449:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80144d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801450:	89 c0                	mov    %eax,%eax
  801452:	48 01 d0             	add    %rdx,%rax
  801455:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801458:	83 c2 08             	add    $0x8,%edx
  80145b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80145e:	eb 0f                	jmp    80146f <vprintfmt+0x2a5>
  801460:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801464:	48 89 d0             	mov    %rdx,%rax
  801467:	48 83 c2 08          	add    $0x8,%rdx
  80146b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80146f:	4c 8b 20             	mov    (%rax),%r12
  801472:	4d 85 e4             	test   %r12,%r12
  801475:	75 0a                	jne    801481 <vprintfmt+0x2b7>
				p = "(null)";
  801477:	49 bc 2d 5a 80 00 00 	movabs $0x805a2d,%r12
  80147e:	00 00 00 
			if (width > 0 && padc != '-')
  801481:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801485:	7e 3f                	jle    8014c6 <vprintfmt+0x2fc>
  801487:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80148b:	74 39                	je     8014c6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80148d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801490:	48 98                	cltq   
  801492:	48 89 c6             	mov    %rax,%rsi
  801495:	4c 89 e7             	mov    %r12,%rdi
  801498:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  80149f:	00 00 00 
  8014a2:	ff d0                	callq  *%rax
  8014a4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8014a7:	eb 17                	jmp    8014c0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8014a9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8014ad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014b5:	48 89 ce             	mov    %rcx,%rsi
  8014b8:	89 d7                	mov    %edx,%edi
  8014ba:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8014bc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8014c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8014c4:	7f e3                	jg     8014a9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014c6:	eb 37                	jmp    8014ff <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8014c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8014cc:	74 1e                	je     8014ec <vprintfmt+0x322>
  8014ce:	83 fb 1f             	cmp    $0x1f,%ebx
  8014d1:	7e 05                	jle    8014d8 <vprintfmt+0x30e>
  8014d3:	83 fb 7e             	cmp    $0x7e,%ebx
  8014d6:	7e 14                	jle    8014ec <vprintfmt+0x322>
					putch('?', putdat);
  8014d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014e0:	48 89 d6             	mov    %rdx,%rsi
  8014e3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8014e8:	ff d0                	callq  *%rax
  8014ea:	eb 0f                	jmp    8014fb <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8014ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014f4:	48 89 d6             	mov    %rdx,%rsi
  8014f7:	89 df                	mov    %ebx,%edi
  8014f9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014fb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8014ff:	4c 89 e0             	mov    %r12,%rax
  801502:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	0f be d8             	movsbl %al,%ebx
  80150c:	85 db                	test   %ebx,%ebx
  80150e:	74 10                	je     801520 <vprintfmt+0x356>
  801510:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801514:	78 b2                	js     8014c8 <vprintfmt+0x2fe>
  801516:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80151a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80151e:	79 a8                	jns    8014c8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801520:	eb 16                	jmp    801538 <vprintfmt+0x36e>
				putch(' ', putdat);
  801522:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801526:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80152a:	48 89 d6             	mov    %rdx,%rsi
  80152d:	bf 20 00 00 00       	mov    $0x20,%edi
  801532:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801534:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801538:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80153c:	7f e4                	jg     801522 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80153e:	e9 90 01 00 00       	jmpq   8016d3 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801543:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801547:	be 03 00 00 00       	mov    $0x3,%esi
  80154c:	48 89 c7             	mov    %rax,%rdi
  80154f:	48 b8 ba 10 80 00 00 	movabs $0x8010ba,%rax
  801556:	00 00 00 
  801559:	ff d0                	callq  *%rax
  80155b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801563:	48 85 c0             	test   %rax,%rax
  801566:	79 1d                	jns    801585 <vprintfmt+0x3bb>
				putch('-', putdat);
  801568:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80156c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801570:	48 89 d6             	mov    %rdx,%rsi
  801573:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801578:	ff d0                	callq  *%rax
				num = -(long long) num;
  80157a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157e:	48 f7 d8             	neg    %rax
  801581:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801585:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80158c:	e9 d5 00 00 00       	jmpq   801666 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801591:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801595:	be 03 00 00 00       	mov    $0x3,%esi
  80159a:	48 89 c7             	mov    %rax,%rdi
  80159d:	48 b8 aa 0f 80 00 00 	movabs $0x800faa,%rax
  8015a4:	00 00 00 
  8015a7:	ff d0                	callq  *%rax
  8015a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8015ad:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8015b4:	e9 ad 00 00 00       	jmpq   801666 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8015b9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8015bd:	be 03 00 00 00       	mov    $0x3,%esi
  8015c2:	48 89 c7             	mov    %rax,%rdi
  8015c5:	48 b8 aa 0f 80 00 00 	movabs $0x800faa,%rax
  8015cc:	00 00 00 
  8015cf:	ff d0                	callq  *%rax
  8015d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8015d5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8015dc:	e9 85 00 00 00       	jmpq   801666 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8015e1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015e9:	48 89 d6             	mov    %rdx,%rsi
  8015ec:	bf 30 00 00 00       	mov    $0x30,%edi
  8015f1:	ff d0                	callq  *%rax
			putch('x', putdat);
  8015f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015fb:	48 89 d6             	mov    %rdx,%rsi
  8015fe:	bf 78 00 00 00       	mov    $0x78,%edi
  801603:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801605:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801608:	83 f8 30             	cmp    $0x30,%eax
  80160b:	73 17                	jae    801624 <vprintfmt+0x45a>
  80160d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801611:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801614:	89 c0                	mov    %eax,%eax
  801616:	48 01 d0             	add    %rdx,%rax
  801619:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80161c:	83 c2 08             	add    $0x8,%edx
  80161f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801622:	eb 0f                	jmp    801633 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801624:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801628:	48 89 d0             	mov    %rdx,%rax
  80162b:	48 83 c2 08          	add    $0x8,%rdx
  80162f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801633:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801636:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80163a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801641:	eb 23                	jmp    801666 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801643:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801647:	be 03 00 00 00       	mov    $0x3,%esi
  80164c:	48 89 c7             	mov    %rax,%rdi
  80164f:	48 b8 aa 0f 80 00 00 	movabs $0x800faa,%rax
  801656:	00 00 00 
  801659:	ff d0                	callq  *%rax
  80165b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80165f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801666:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80166b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80166e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801671:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801675:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801679:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80167d:	45 89 c1             	mov    %r8d,%r9d
  801680:	41 89 f8             	mov    %edi,%r8d
  801683:	48 89 c7             	mov    %rax,%rdi
  801686:	48 b8 ef 0e 80 00 00 	movabs $0x800eef,%rax
  80168d:	00 00 00 
  801690:	ff d0                	callq  *%rax
			break;
  801692:	eb 3f                	jmp    8016d3 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801694:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801698:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80169c:	48 89 d6             	mov    %rdx,%rsi
  80169f:	89 df                	mov    %ebx,%edi
  8016a1:	ff d0                	callq  *%rax
			break;
  8016a3:	eb 2e                	jmp    8016d3 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016ad:	48 89 d6             	mov    %rdx,%rsi
  8016b0:	bf 25 00 00 00       	mov    $0x25,%edi
  8016b5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016b7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8016bc:	eb 05                	jmp    8016c3 <vprintfmt+0x4f9>
  8016be:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8016c3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8016c7:	48 83 e8 01          	sub    $0x1,%rax
  8016cb:	0f b6 00             	movzbl (%rax),%eax
  8016ce:	3c 25                	cmp    $0x25,%al
  8016d0:	75 ec                	jne    8016be <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8016d2:	90                   	nop
		}
	}
  8016d3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016d4:	e9 43 fb ff ff       	jmpq   80121c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8016d9:	48 83 c4 60          	add    $0x60,%rsp
  8016dd:	5b                   	pop    %rbx
  8016de:	41 5c                	pop    %r12
  8016e0:	5d                   	pop    %rbp
  8016e1:	c3                   	retq   

00000000008016e2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8016e2:	55                   	push   %rbp
  8016e3:	48 89 e5             	mov    %rsp,%rbp
  8016e6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8016ed:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8016f4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8016fb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801702:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801709:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801710:	84 c0                	test   %al,%al
  801712:	74 20                	je     801734 <printfmt+0x52>
  801714:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801718:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80171c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801720:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801724:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801728:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80172c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801730:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801734:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80173b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801742:	00 00 00 
  801745:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80174c:	00 00 00 
  80174f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801753:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80175a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801761:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801768:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80176f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801776:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80177d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801784:	48 89 c7             	mov    %rax,%rdi
  801787:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80178e:	00 00 00 
  801791:	ff d0                	callq  *%rax
	va_end(ap);
}
  801793:	c9                   	leaveq 
  801794:	c3                   	retq   

0000000000801795 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	48 83 ec 10          	sub    $0x10,%rsp
  80179d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8017a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a8:	8b 40 10             	mov    0x10(%rax),%eax
  8017ab:	8d 50 01             	lea    0x1(%rax),%edx
  8017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8017b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b9:	48 8b 10             	mov    (%rax),%rdx
  8017bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8017c4:	48 39 c2             	cmp    %rax,%rdx
  8017c7:	73 17                	jae    8017e0 <sprintputch+0x4b>
		*b->buf++ = ch;
  8017c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cd:	48 8b 00             	mov    (%rax),%rax
  8017d0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8017d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d8:	48 89 0a             	mov    %rcx,(%rdx)
  8017db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8017de:	88 10                	mov    %dl,(%rax)
}
  8017e0:	c9                   	leaveq 
  8017e1:	c3                   	retq   

00000000008017e2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 83 ec 50          	sub    $0x50,%rsp
  8017ea:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8017ee:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8017f1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8017f5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8017f9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8017fd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801801:	48 8b 0a             	mov    (%rdx),%rcx
  801804:	48 89 08             	mov    %rcx,(%rax)
  801807:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80180b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80180f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801813:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801817:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80181b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80181f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801822:	48 98                	cltq   
  801824:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801828:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80182c:	48 01 d0             	add    %rdx,%rax
  80182f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801833:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80183a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80183f:	74 06                	je     801847 <vsnprintf+0x65>
  801841:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801845:	7f 07                	jg     80184e <vsnprintf+0x6c>
		return -E_INVAL;
  801847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80184c:	eb 2f                	jmp    80187d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80184e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801852:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801856:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80185a:	48 89 c6             	mov    %rax,%rsi
  80185d:	48 bf 95 17 80 00 00 	movabs $0x801795,%rdi
  801864:	00 00 00 
  801867:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801873:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801877:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80187a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   

000000000080187f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80188a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801891:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801897:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80189e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8018a5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 20                	je     8018d0 <snprintf+0x51>
  8018b0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8018b4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8018b8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8018bc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8018c0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8018c4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8018c8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8018cc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8018d0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8018d7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8018de:	00 00 00 
  8018e1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8018e8:	00 00 00 
  8018eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8018ef:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8018f6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018fd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801904:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80190b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801912:	48 8b 0a             	mov    (%rdx),%rcx
  801915:	48 89 08             	mov    %rcx,(%rax)
  801918:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80191c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801920:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801924:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801928:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80192f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801936:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80193c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801943:	48 89 c7             	mov    %rax,%rdi
  801946:	48 b8 e2 17 80 00 00 	movabs $0x8017e2,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
  801952:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801958:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80195e:	c9                   	leaveq 
  80195f:	c3                   	retq   

0000000000801960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
  801964:	48 83 ec 18          	sub    $0x18,%rsp
  801968:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80196c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801973:	eb 09                	jmp    80197e <strlen+0x1e>
		n++;
  801975:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801979:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80197e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801982:	0f b6 00             	movzbl (%rax),%eax
  801985:	84 c0                	test   %al,%al
  801987:	75 ec                	jne    801975 <strlen+0x15>
		n++;
	return n;
  801989:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	48 83 ec 20          	sub    $0x20,%rsp
  801996:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80199a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80199e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8019a5:	eb 0e                	jmp    8019b5 <strnlen+0x27>
		n++;
  8019a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019b0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8019b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8019ba:	74 0b                	je     8019c7 <strnlen+0x39>
  8019bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c0:	0f b6 00             	movzbl (%rax),%eax
  8019c3:	84 c0                	test   %al,%al
  8019c5:	75 e0                	jne    8019a7 <strnlen+0x19>
		n++;
	return n;
  8019c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8019ca:	c9                   	leaveq 
  8019cb:	c3                   	retq   

00000000008019cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	48 83 ec 20          	sub    $0x20,%rsp
  8019d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8019dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8019e4:	90                   	nop
  8019e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019f5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8019f9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8019fd:	0f b6 12             	movzbl (%rdx),%edx
  801a00:	88 10                	mov    %dl,(%rax)
  801a02:	0f b6 00             	movzbl (%rax),%eax
  801a05:	84 c0                	test   %al,%al
  801a07:	75 dc                	jne    8019e5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a0d:	c9                   	leaveq 
  801a0e:	c3                   	retq   

0000000000801a0f <strcat>:

char *
strcat(char *dst, const char *src)
{
  801a0f:	55                   	push   %rbp
  801a10:	48 89 e5             	mov    %rsp,%rbp
  801a13:	48 83 ec 20          	sub    $0x20,%rsp
  801a17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a23:	48 89 c7             	mov    %rax,%rdi
  801a26:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  801a2d:	00 00 00 
  801a30:	ff d0                	callq  *%rax
  801a32:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a38:	48 63 d0             	movslq %eax,%rdx
  801a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a3f:	48 01 c2             	add    %rax,%rdx
  801a42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a46:	48 89 c6             	mov    %rax,%rsi
  801a49:	48 89 d7             	mov    %rdx,%rdi
  801a4c:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801a53:	00 00 00 
  801a56:	ff d0                	callq  *%rax
	return dst;
  801a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a5c:	c9                   	leaveq 
  801a5d:	c3                   	retq   

0000000000801a5e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801a5e:	55                   	push   %rbp
  801a5f:	48 89 e5             	mov    %rsp,%rbp
  801a62:	48 83 ec 28          	sub    $0x28,%rsp
  801a66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a6e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801a7a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a81:	00 
  801a82:	eb 2a                	jmp    801aae <strncpy+0x50>
		*dst++ = *src;
  801a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a88:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a8c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a90:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a94:	0f b6 12             	movzbl (%rdx),%edx
  801a97:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801a99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a9d:	0f b6 00             	movzbl (%rax),%eax
  801aa0:	84 c0                	test   %al,%al
  801aa2:	74 05                	je     801aa9 <strncpy+0x4b>
			src++;
  801aa4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801aa9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801aae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801ab6:	72 cc                	jb     801a84 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801abc:	c9                   	leaveq 
  801abd:	c3                   	retq   

0000000000801abe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801abe:	55                   	push   %rbp
  801abf:	48 89 e5             	mov    %rsp,%rbp
  801ac2:	48 83 ec 28          	sub    $0x28,%rsp
  801ac6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801aca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ace:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801ad2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801ada:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801adf:	74 3d                	je     801b1e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801ae1:	eb 1d                	jmp    801b00 <strlcpy+0x42>
			*dst++ = *src++;
  801ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aeb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801aef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801af3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801af7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801afb:	0f b6 12             	movzbl (%rdx),%edx
  801afe:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801b00:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801b05:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801b0a:	74 0b                	je     801b17 <strlcpy+0x59>
  801b0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b10:	0f b6 00             	movzbl (%rax),%eax
  801b13:	84 c0                	test   %al,%al
  801b15:	75 cc                	jne    801ae3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b1b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801b1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b26:	48 29 c2             	sub    %rax,%rdx
  801b29:	48 89 d0             	mov    %rdx,%rax
}
  801b2c:	c9                   	leaveq 
  801b2d:	c3                   	retq   

0000000000801b2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801b2e:	55                   	push   %rbp
  801b2f:	48 89 e5             	mov    %rsp,%rbp
  801b32:	48 83 ec 10          	sub    $0x10,%rsp
  801b36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801b3e:	eb 0a                	jmp    801b4a <strcmp+0x1c>
		p++, q++;
  801b40:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b45:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b4e:	0f b6 00             	movzbl (%rax),%eax
  801b51:	84 c0                	test   %al,%al
  801b53:	74 12                	je     801b67 <strcmp+0x39>
  801b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b59:	0f b6 10             	movzbl (%rax),%edx
  801b5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b60:	0f b6 00             	movzbl (%rax),%eax
  801b63:	38 c2                	cmp    %al,%dl
  801b65:	74 d9                	je     801b40 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6b:	0f b6 00             	movzbl (%rax),%eax
  801b6e:	0f b6 d0             	movzbl %al,%edx
  801b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b75:	0f b6 00             	movzbl (%rax),%eax
  801b78:	0f b6 c0             	movzbl %al,%eax
  801b7b:	29 c2                	sub    %eax,%edx
  801b7d:	89 d0                	mov    %edx,%eax
}
  801b7f:	c9                   	leaveq 
  801b80:	c3                   	retq   

0000000000801b81 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801b81:	55                   	push   %rbp
  801b82:	48 89 e5             	mov    %rsp,%rbp
  801b85:	48 83 ec 18          	sub    $0x18,%rsp
  801b89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b91:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801b95:	eb 0f                	jmp    801ba6 <strncmp+0x25>
		n--, p++, q++;
  801b97:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801b9c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ba1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ba6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bab:	74 1d                	je     801bca <strncmp+0x49>
  801bad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb1:	0f b6 00             	movzbl (%rax),%eax
  801bb4:	84 c0                	test   %al,%al
  801bb6:	74 12                	je     801bca <strncmp+0x49>
  801bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbc:	0f b6 10             	movzbl (%rax),%edx
  801bbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc3:	0f b6 00             	movzbl (%rax),%eax
  801bc6:	38 c2                	cmp    %al,%dl
  801bc8:	74 cd                	je     801b97 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801bca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bcf:	75 07                	jne    801bd8 <strncmp+0x57>
		return 0;
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd6:	eb 18                	jmp    801bf0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bdc:	0f b6 00             	movzbl (%rax),%eax
  801bdf:	0f b6 d0             	movzbl %al,%edx
  801be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801be6:	0f b6 00             	movzbl (%rax),%eax
  801be9:	0f b6 c0             	movzbl %al,%eax
  801bec:	29 c2                	sub    %eax,%edx
  801bee:	89 d0                	mov    %edx,%eax
}
  801bf0:	c9                   	leaveq 
  801bf1:	c3                   	retq   

0000000000801bf2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	48 83 ec 0c          	sub    $0xc,%rsp
  801bfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bfe:	89 f0                	mov    %esi,%eax
  801c00:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801c03:	eb 17                	jmp    801c1c <strchr+0x2a>
		if (*s == c)
  801c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c09:	0f b6 00             	movzbl (%rax),%eax
  801c0c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801c0f:	75 06                	jne    801c17 <strchr+0x25>
			return (char *) s;
  801c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c15:	eb 15                	jmp    801c2c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c17:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c20:	0f b6 00             	movzbl (%rax),%eax
  801c23:	84 c0                	test   %al,%al
  801c25:	75 de                	jne    801c05 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2c:	c9                   	leaveq 
  801c2d:	c3                   	retq   

0000000000801c2e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c2e:	55                   	push   %rbp
  801c2f:	48 89 e5             	mov    %rsp,%rbp
  801c32:	48 83 ec 0c          	sub    $0xc,%rsp
  801c36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c3a:	89 f0                	mov    %esi,%eax
  801c3c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801c3f:	eb 13                	jmp    801c54 <strfind+0x26>
		if (*s == c)
  801c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c45:	0f b6 00             	movzbl (%rax),%eax
  801c48:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801c4b:	75 02                	jne    801c4f <strfind+0x21>
			break;
  801c4d:	eb 10                	jmp    801c5f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801c4f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c58:	0f b6 00             	movzbl (%rax),%eax
  801c5b:	84 c0                	test   %al,%al
  801c5d:	75 e2                	jne    801c41 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c63:	c9                   	leaveq 
  801c64:	c3                   	retq   

0000000000801c65 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801c65:	55                   	push   %rbp
  801c66:	48 89 e5             	mov    %rsp,%rbp
  801c69:	48 83 ec 18          	sub    $0x18,%rsp
  801c6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c71:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801c74:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801c78:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c7d:	75 06                	jne    801c85 <memset+0x20>
		return v;
  801c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c83:	eb 69                	jmp    801cee <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801c85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c89:	83 e0 03             	and    $0x3,%eax
  801c8c:	48 85 c0             	test   %rax,%rax
  801c8f:	75 48                	jne    801cd9 <memset+0x74>
  801c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c95:	83 e0 03             	and    $0x3,%eax
  801c98:	48 85 c0             	test   %rax,%rax
  801c9b:	75 3c                	jne    801cd9 <memset+0x74>
		c &= 0xFF;
  801c9d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ca4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ca7:	c1 e0 18             	shl    $0x18,%eax
  801caa:	89 c2                	mov    %eax,%edx
  801cac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801caf:	c1 e0 10             	shl    $0x10,%eax
  801cb2:	09 c2                	or     %eax,%edx
  801cb4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cb7:	c1 e0 08             	shl    $0x8,%eax
  801cba:	09 d0                	or     %edx,%eax
  801cbc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc3:	48 c1 e8 02          	shr    $0x2,%rax
  801cc7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801cca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cd1:	48 89 d7             	mov    %rdx,%rdi
  801cd4:	fc                   	cld    
  801cd5:	f3 ab                	rep stos %eax,%es:(%rdi)
  801cd7:	eb 11                	jmp    801cea <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cd9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cdd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ce0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ce4:	48 89 d7             	mov    %rdx,%rdi
  801ce7:	fc                   	cld    
  801ce8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801cee:	c9                   	leaveq 
  801cef:	c3                   	retq   

0000000000801cf0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801cf0:	55                   	push   %rbp
  801cf1:	48 89 e5             	mov    %rsp,%rbp
  801cf4:	48 83 ec 28          	sub    $0x28,%rsp
  801cf8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801d04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801d14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d18:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801d1c:	0f 83 88 00 00 00    	jae    801daa <memmove+0xba>
  801d22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d26:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d2a:	48 01 d0             	add    %rdx,%rax
  801d2d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801d31:	76 77                	jbe    801daa <memmove+0xba>
		s += n;
  801d33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d37:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801d3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d3f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801d43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d47:	83 e0 03             	and    $0x3,%eax
  801d4a:	48 85 c0             	test   %rax,%rax
  801d4d:	75 3b                	jne    801d8a <memmove+0x9a>
  801d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d53:	83 e0 03             	and    $0x3,%eax
  801d56:	48 85 c0             	test   %rax,%rax
  801d59:	75 2f                	jne    801d8a <memmove+0x9a>
  801d5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d5f:	83 e0 03             	and    $0x3,%eax
  801d62:	48 85 c0             	test   %rax,%rax
  801d65:	75 23                	jne    801d8a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6b:	48 83 e8 04          	sub    $0x4,%rax
  801d6f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d73:	48 83 ea 04          	sub    $0x4,%rdx
  801d77:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d7b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801d7f:	48 89 c7             	mov    %rax,%rdi
  801d82:	48 89 d6             	mov    %rdx,%rsi
  801d85:	fd                   	std    
  801d86:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d88:	eb 1d                	jmp    801da7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801d92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d96:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801d9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9e:	48 89 d7             	mov    %rdx,%rdi
  801da1:	48 89 c1             	mov    %rax,%rcx
  801da4:	fd                   	std    
  801da5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801da7:	fc                   	cld    
  801da8:	eb 57                	jmp    801e01 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801daa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dae:	83 e0 03             	and    $0x3,%eax
  801db1:	48 85 c0             	test   %rax,%rax
  801db4:	75 36                	jne    801dec <memmove+0xfc>
  801db6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dba:	83 e0 03             	and    $0x3,%eax
  801dbd:	48 85 c0             	test   %rax,%rax
  801dc0:	75 2a                	jne    801dec <memmove+0xfc>
  801dc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc6:	83 e0 03             	and    $0x3,%eax
  801dc9:	48 85 c0             	test   %rax,%rax
  801dcc:	75 1e                	jne    801dec <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801dce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd2:	48 c1 e8 02          	shr    $0x2,%rax
  801dd6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801de1:	48 89 c7             	mov    %rax,%rdi
  801de4:	48 89 d6             	mov    %rdx,%rsi
  801de7:	fc                   	cld    
  801de8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801dea:	eb 15                	jmp    801e01 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801df4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801df8:	48 89 c7             	mov    %rax,%rdi
  801dfb:	48 89 d6             	mov    %rdx,%rsi
  801dfe:	fc                   	cld    
  801dff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e05:	c9                   	leaveq 
  801e06:	c3                   	retq   

0000000000801e07 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e07:	55                   	push   %rbp
  801e08:	48 89 e5             	mov    %rsp,%rbp
  801e0b:	48 83 ec 18          	sub    $0x18,%rsp
  801e0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e17:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801e1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e1f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e27:	48 89 ce             	mov    %rcx,%rsi
  801e2a:	48 89 c7             	mov    %rax,%rdi
  801e2d:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  801e34:	00 00 00 
  801e37:	ff d0                	callq  *%rax
}
  801e39:	c9                   	leaveq 
  801e3a:	c3                   	retq   

0000000000801e3b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e3b:	55                   	push   %rbp
  801e3c:	48 89 e5             	mov    %rsp,%rbp
  801e3f:	48 83 ec 28          	sub    $0x28,%rsp
  801e43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801e57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801e5f:	eb 36                	jmp    801e97 <memcmp+0x5c>
		if (*s1 != *s2)
  801e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e65:	0f b6 10             	movzbl (%rax),%edx
  801e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e6c:	0f b6 00             	movzbl (%rax),%eax
  801e6f:	38 c2                	cmp    %al,%dl
  801e71:	74 1a                	je     801e8d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e77:	0f b6 00             	movzbl (%rax),%eax
  801e7a:	0f b6 d0             	movzbl %al,%edx
  801e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e81:	0f b6 00             	movzbl (%rax),%eax
  801e84:	0f b6 c0             	movzbl %al,%eax
  801e87:	29 c2                	sub    %eax,%edx
  801e89:	89 d0                	mov    %edx,%eax
  801e8b:	eb 20                	jmp    801ead <memcmp+0x72>
		s1++, s2++;
  801e8d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801e92:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e9f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ea3:	48 85 c0             	test   %rax,%rax
  801ea6:	75 b9                	jne    801e61 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ead:	c9                   	leaveq 
  801eae:	c3                   	retq   

0000000000801eaf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801eaf:	55                   	push   %rbp
  801eb0:	48 89 e5             	mov    %rsp,%rbp
  801eb3:	48 83 ec 28          	sub    $0x28,%rsp
  801eb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ebb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801ebe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801ec2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801eca:	48 01 d0             	add    %rdx,%rax
  801ecd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801ed1:	eb 15                	jmp    801ee8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed7:	0f b6 10             	movzbl (%rax),%edx
  801eda:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801edd:	38 c2                	cmp    %al,%dl
  801edf:	75 02                	jne    801ee3 <memfind+0x34>
			break;
  801ee1:	eb 0f                	jmp    801ef2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ee3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eec:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801ef0:	72 e1                	jb     801ed3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ef6:	c9                   	leaveq 
  801ef7:	c3                   	retq   

0000000000801ef8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ef8:	55                   	push   %rbp
  801ef9:	48 89 e5             	mov    %rsp,%rbp
  801efc:	48 83 ec 34          	sub    $0x34,%rsp
  801f00:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f04:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f08:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801f0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801f12:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801f19:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f1a:	eb 05                	jmp    801f21 <strtol+0x29>
		s++;
  801f1c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f25:	0f b6 00             	movzbl (%rax),%eax
  801f28:	3c 20                	cmp    $0x20,%al
  801f2a:	74 f0                	je     801f1c <strtol+0x24>
  801f2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f30:	0f b6 00             	movzbl (%rax),%eax
  801f33:	3c 09                	cmp    $0x9,%al
  801f35:	74 e5                	je     801f1c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3b:	0f b6 00             	movzbl (%rax),%eax
  801f3e:	3c 2b                	cmp    $0x2b,%al
  801f40:	75 07                	jne    801f49 <strtol+0x51>
		s++;
  801f42:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f47:	eb 17                	jmp    801f60 <strtol+0x68>
	else if (*s == '-')
  801f49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4d:	0f b6 00             	movzbl (%rax),%eax
  801f50:	3c 2d                	cmp    $0x2d,%al
  801f52:	75 0c                	jne    801f60 <strtol+0x68>
		s++, neg = 1;
  801f54:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f59:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f60:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f64:	74 06                	je     801f6c <strtol+0x74>
  801f66:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801f6a:	75 28                	jne    801f94 <strtol+0x9c>
  801f6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f70:	0f b6 00             	movzbl (%rax),%eax
  801f73:	3c 30                	cmp    $0x30,%al
  801f75:	75 1d                	jne    801f94 <strtol+0x9c>
  801f77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f7b:	48 83 c0 01          	add    $0x1,%rax
  801f7f:	0f b6 00             	movzbl (%rax),%eax
  801f82:	3c 78                	cmp    $0x78,%al
  801f84:	75 0e                	jne    801f94 <strtol+0x9c>
		s += 2, base = 16;
  801f86:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801f8b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801f92:	eb 2c                	jmp    801fc0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801f94:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f98:	75 19                	jne    801fb3 <strtol+0xbb>
  801f9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9e:	0f b6 00             	movzbl (%rax),%eax
  801fa1:	3c 30                	cmp    $0x30,%al
  801fa3:	75 0e                	jne    801fb3 <strtol+0xbb>
		s++, base = 8;
  801fa5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801faa:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801fb1:	eb 0d                	jmp    801fc0 <strtol+0xc8>
	else if (base == 0)
  801fb3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801fb7:	75 07                	jne    801fc0 <strtol+0xc8>
		base = 10;
  801fb9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc4:	0f b6 00             	movzbl (%rax),%eax
  801fc7:	3c 2f                	cmp    $0x2f,%al
  801fc9:	7e 1d                	jle    801fe8 <strtol+0xf0>
  801fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fcf:	0f b6 00             	movzbl (%rax),%eax
  801fd2:	3c 39                	cmp    $0x39,%al
  801fd4:	7f 12                	jg     801fe8 <strtol+0xf0>
			dig = *s - '0';
  801fd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fda:	0f b6 00             	movzbl (%rax),%eax
  801fdd:	0f be c0             	movsbl %al,%eax
  801fe0:	83 e8 30             	sub    $0x30,%eax
  801fe3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fe6:	eb 4e                	jmp    802036 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fec:	0f b6 00             	movzbl (%rax),%eax
  801fef:	3c 60                	cmp    $0x60,%al
  801ff1:	7e 1d                	jle    802010 <strtol+0x118>
  801ff3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff7:	0f b6 00             	movzbl (%rax),%eax
  801ffa:	3c 7a                	cmp    $0x7a,%al
  801ffc:	7f 12                	jg     802010 <strtol+0x118>
			dig = *s - 'a' + 10;
  801ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802002:	0f b6 00             	movzbl (%rax),%eax
  802005:	0f be c0             	movsbl %al,%eax
  802008:	83 e8 57             	sub    $0x57,%eax
  80200b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80200e:	eb 26                	jmp    802036 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802010:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802014:	0f b6 00             	movzbl (%rax),%eax
  802017:	3c 40                	cmp    $0x40,%al
  802019:	7e 48                	jle    802063 <strtol+0x16b>
  80201b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201f:	0f b6 00             	movzbl (%rax),%eax
  802022:	3c 5a                	cmp    $0x5a,%al
  802024:	7f 3d                	jg     802063 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802026:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202a:	0f b6 00             	movzbl (%rax),%eax
  80202d:	0f be c0             	movsbl %al,%eax
  802030:	83 e8 37             	sub    $0x37,%eax
  802033:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802036:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802039:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80203c:	7c 02                	jl     802040 <strtol+0x148>
			break;
  80203e:	eb 23                	jmp    802063 <strtol+0x16b>
		s++, val = (val * base) + dig;
  802040:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802045:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802048:	48 98                	cltq   
  80204a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80204f:	48 89 c2             	mov    %rax,%rdx
  802052:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802055:	48 98                	cltq   
  802057:	48 01 d0             	add    %rdx,%rax
  80205a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80205e:	e9 5d ff ff ff       	jmpq   801fc0 <strtol+0xc8>

	if (endptr)
  802063:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802068:	74 0b                	je     802075 <strtol+0x17d>
		*endptr = (char *) s;
  80206a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80206e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802072:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802075:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802079:	74 09                	je     802084 <strtol+0x18c>
  80207b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80207f:	48 f7 d8             	neg    %rax
  802082:	eb 04                	jmp    802088 <strtol+0x190>
  802084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802088:	c9                   	leaveq 
  802089:	c3                   	retq   

000000000080208a <strstr>:

char * strstr(const char *in, const char *str)
{
  80208a:	55                   	push   %rbp
  80208b:	48 89 e5             	mov    %rsp,%rbp
  80208e:	48 83 ec 30          	sub    $0x30,%rsp
  802092:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802096:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80209a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80209e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8020a2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8020a6:	0f b6 00             	movzbl (%rax),%eax
  8020a9:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8020ac:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8020b0:	75 06                	jne    8020b8 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8020b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b6:	eb 6b                	jmp    802123 <strstr+0x99>

	len = strlen(str);
  8020b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020bc:	48 89 c7             	mov    %rax,%rdi
  8020bf:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax
  8020cb:	48 98                	cltq   
  8020cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8020d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8020d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8020dd:	0f b6 00             	movzbl (%rax),%eax
  8020e0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8020e3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8020e7:	75 07                	jne    8020f0 <strstr+0x66>
				return (char *) 0;
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	eb 33                	jmp    802123 <strstr+0x99>
		} while (sc != c);
  8020f0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8020f4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8020f7:	75 d8                	jne    8020d1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8020f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020fd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802101:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802105:	48 89 ce             	mov    %rcx,%rsi
  802108:	48 89 c7             	mov    %rax,%rdi
  80210b:	48 b8 81 1b 80 00 00 	movabs $0x801b81,%rax
  802112:	00 00 00 
  802115:	ff d0                	callq  *%rax
  802117:	85 c0                	test   %eax,%eax
  802119:	75 b6                	jne    8020d1 <strstr+0x47>

	return (char *) (in - 1);
  80211b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211f:	48 83 e8 01          	sub    $0x1,%rax
}
  802123:	c9                   	leaveq 
  802124:	c3                   	retq   

0000000000802125 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802125:	55                   	push   %rbp
  802126:	48 89 e5             	mov    %rsp,%rbp
  802129:	53                   	push   %rbx
  80212a:	48 83 ec 48          	sub    $0x48,%rsp
  80212e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802131:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802134:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802138:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80213c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802140:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802144:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802147:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80214b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80214f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802153:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802157:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80215b:	4c 89 c3             	mov    %r8,%rbx
  80215e:	cd 30                	int    $0x30
  802160:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802164:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802168:	74 3e                	je     8021a8 <syscall+0x83>
  80216a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80216f:	7e 37                	jle    8021a8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802171:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802175:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802178:	49 89 d0             	mov    %rdx,%r8
  80217b:	89 c1                	mov    %eax,%ecx
  80217d:	48 ba e8 5c 80 00 00 	movabs $0x805ce8,%rdx
  802184:	00 00 00 
  802187:	be 24 00 00 00       	mov    $0x24,%esi
  80218c:	48 bf 05 5d 80 00 00 	movabs $0x805d05,%rdi
  802193:	00 00 00 
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	49 b9 de 0b 80 00 00 	movabs $0x800bde,%r9
  8021a2:	00 00 00 
  8021a5:	41 ff d1             	callq  *%r9

	return ret;
  8021a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8021ac:	48 83 c4 48          	add    $0x48,%rsp
  8021b0:	5b                   	pop    %rbx
  8021b1:	5d                   	pop    %rbp
  8021b2:	c3                   	retq   

00000000008021b3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8021b3:	55                   	push   %rbp
  8021b4:	48 89 e5             	mov    %rsp,%rbp
  8021b7:	48 83 ec 20          	sub    $0x20,%rsp
  8021bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8021c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d2:	00 
  8021d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021df:	48 89 d1             	mov    %rdx,%rcx
  8021e2:	48 89 c2             	mov    %rax,%rdx
  8021e5:	be 00 00 00 00       	mov    $0x0,%esi
  8021ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ef:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8021f6:	00 00 00 
  8021f9:	ff d0                	callq  *%rax
}
  8021fb:	c9                   	leaveq 
  8021fc:	c3                   	retq   

00000000008021fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8021fd:	55                   	push   %rbp
  8021fe:	48 89 e5             	mov    %rsp,%rbp
  802201:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802205:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80220c:	00 
  80220d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802213:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802219:	b9 00 00 00 00       	mov    $0x0,%ecx
  80221e:	ba 00 00 00 00       	mov    $0x0,%edx
  802223:	be 00 00 00 00       	mov    $0x0,%esi
  802228:	bf 01 00 00 00       	mov    $0x1,%edi
  80222d:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
}
  802239:	c9                   	leaveq 
  80223a:	c3                   	retq   

000000000080223b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80223b:	55                   	push   %rbp
  80223c:	48 89 e5             	mov    %rsp,%rbp
  80223f:	48 83 ec 10          	sub    $0x10,%rsp
  802243:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802249:	48 98                	cltq   
  80224b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802252:	00 
  802253:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802259:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80225f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802264:	48 89 c2             	mov    %rax,%rdx
  802267:	be 01 00 00 00       	mov    $0x1,%esi
  80226c:	bf 03 00 00 00       	mov    $0x3,%edi
  802271:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802278:	00 00 00 
  80227b:	ff d0                	callq  *%rax
}
  80227d:	c9                   	leaveq 
  80227e:	c3                   	retq   

000000000080227f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80227f:	55                   	push   %rbp
  802280:	48 89 e5             	mov    %rsp,%rbp
  802283:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802287:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80228e:	00 
  80228f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80229b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a5:	be 00 00 00 00       	mov    $0x0,%esi
  8022aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8022af:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8022b6:	00 00 00 
  8022b9:	ff d0                	callq  *%rax
}
  8022bb:	c9                   	leaveq 
  8022bc:	c3                   	retq   

00000000008022bd <sys_yield>:


void
sys_yield(void)
{
  8022bd:	55                   	push   %rbp
  8022be:	48 89 e5             	mov    %rsp,%rbp
  8022c1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8022c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022cc:	00 
  8022cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022de:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e3:	be 00 00 00 00       	mov    $0x0,%esi
  8022e8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8022ed:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
}
  8022f9:	c9                   	leaveq 
  8022fa:	c3                   	retq   

00000000008022fb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8022fb:	55                   	push   %rbp
  8022fc:	48 89 e5             	mov    %rsp,%rbp
  8022ff:	48 83 ec 20          	sub    $0x20,%rsp
  802303:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802306:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80230a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80230d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802310:	48 63 c8             	movslq %eax,%rcx
  802313:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231a:	48 98                	cltq   
  80231c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802323:	00 
  802324:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80232a:	49 89 c8             	mov    %rcx,%r8
  80232d:	48 89 d1             	mov    %rdx,%rcx
  802330:	48 89 c2             	mov    %rax,%rdx
  802333:	be 01 00 00 00       	mov    $0x1,%esi
  802338:	bf 04 00 00 00       	mov    $0x4,%edi
  80233d:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802344:	00 00 00 
  802347:	ff d0                	callq  *%rax
}
  802349:	c9                   	leaveq 
  80234a:	c3                   	retq   

000000000080234b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80234b:	55                   	push   %rbp
  80234c:	48 89 e5             	mov    %rsp,%rbp
  80234f:	48 83 ec 30          	sub    $0x30,%rsp
  802353:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802356:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80235a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80235d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802361:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802365:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802368:	48 63 c8             	movslq %eax,%rcx
  80236b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80236f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802372:	48 63 f0             	movslq %eax,%rsi
  802375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237c:	48 98                	cltq   
  80237e:	48 89 0c 24          	mov    %rcx,(%rsp)
  802382:	49 89 f9             	mov    %rdi,%r9
  802385:	49 89 f0             	mov    %rsi,%r8
  802388:	48 89 d1             	mov    %rdx,%rcx
  80238b:	48 89 c2             	mov    %rax,%rdx
  80238e:	be 01 00 00 00       	mov    $0x1,%esi
  802393:	bf 05 00 00 00       	mov    $0x5,%edi
  802398:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax
}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 20          	sub    $0x20,%rsp
  8023ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8023b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bc:	48 98                	cltq   
  8023be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023c5:	00 
  8023c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023d2:	48 89 d1             	mov    %rdx,%rcx
  8023d5:	48 89 c2             	mov    %rax,%rdx
  8023d8:	be 01 00 00 00       	mov    $0x1,%esi
  8023dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8023e2:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax
}
  8023ee:	c9                   	leaveq 
  8023ef:	c3                   	retq   

00000000008023f0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8023f0:	55                   	push   %rbp
  8023f1:	48 89 e5             	mov    %rsp,%rbp
  8023f4:	48 83 ec 10          	sub    $0x10,%rsp
  8023f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023fb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8023fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802401:	48 63 d0             	movslq %eax,%rdx
  802404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802407:	48 98                	cltq   
  802409:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802410:	00 
  802411:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802417:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80241d:	48 89 d1             	mov    %rdx,%rcx
  802420:	48 89 c2             	mov    %rax,%rdx
  802423:	be 01 00 00 00       	mov    $0x1,%esi
  802428:	bf 08 00 00 00       	mov    $0x8,%edi
  80242d:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802434:	00 00 00 
  802437:	ff d0                	callq  *%rax
}
  802439:	c9                   	leaveq 
  80243a:	c3                   	retq   

000000000080243b <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80243b:	55                   	push   %rbp
  80243c:	48 89 e5             	mov    %rsp,%rbp
  80243f:	48 83 ec 20          	sub    $0x20,%rsp
  802443:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80244a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80244e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802451:	48 98                	cltq   
  802453:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80245a:	00 
  80245b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802461:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802467:	48 89 d1             	mov    %rdx,%rcx
  80246a:	48 89 c2             	mov    %rax,%rdx
  80246d:	be 01 00 00 00       	mov    $0x1,%esi
  802472:	bf 09 00 00 00       	mov    $0x9,%edi
  802477:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  80247e:	00 00 00 
  802481:	ff d0                	callq  *%rax
}
  802483:	c9                   	leaveq 
  802484:	c3                   	retq   

0000000000802485 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802485:	55                   	push   %rbp
  802486:	48 89 e5             	mov    %rsp,%rbp
  802489:	48 83 ec 20          	sub    $0x20,%rsp
  80248d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802490:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802494:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249b:	48 98                	cltq   
  80249d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024a4:	00 
  8024a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024b1:	48 89 d1             	mov    %rdx,%rcx
  8024b4:	48 89 c2             	mov    %rax,%rdx
  8024b7:	be 01 00 00 00       	mov    $0x1,%esi
  8024bc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8024c1:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	callq  *%rax
}
  8024cd:	c9                   	leaveq 
  8024ce:	c3                   	retq   

00000000008024cf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8024cf:	55                   	push   %rbp
  8024d0:	48 89 e5             	mov    %rsp,%rbp
  8024d3:	48 83 ec 20          	sub    $0x20,%rsp
  8024d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8024e2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8024e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e8:	48 63 f0             	movslq %eax,%rsi
  8024eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f2:	48 98                	cltq   
  8024f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024ff:	00 
  802500:	49 89 f1             	mov    %rsi,%r9
  802503:	49 89 c8             	mov    %rcx,%r8
  802506:	48 89 d1             	mov    %rdx,%rcx
  802509:	48 89 c2             	mov    %rax,%rdx
  80250c:	be 00 00 00 00       	mov    $0x0,%esi
  802511:	bf 0c 00 00 00       	mov    $0xc,%edi
  802516:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
}
  802522:	c9                   	leaveq 
  802523:	c3                   	retq   

0000000000802524 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802524:	55                   	push   %rbp
  802525:	48 89 e5             	mov    %rsp,%rbp
  802528:	48 83 ec 10          	sub    $0x10,%rsp
  80252c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802534:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80253b:	00 
  80253c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802542:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802548:	b9 00 00 00 00       	mov    $0x0,%ecx
  80254d:	48 89 c2             	mov    %rax,%rdx
  802550:	be 01 00 00 00       	mov    $0x1,%esi
  802555:	bf 0d 00 00 00       	mov    $0xd,%edi
  80255a:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802561:	00 00 00 
  802564:	ff d0                	callq  *%rax
}
  802566:	c9                   	leaveq 
  802567:	c3                   	retq   

0000000000802568 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802568:	55                   	push   %rbp
  802569:	48 89 e5             	mov    %rsp,%rbp
  80256c:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802570:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802577:	00 
  802578:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80257e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802584:	b9 00 00 00 00       	mov    $0x0,%ecx
  802589:	ba 00 00 00 00       	mov    $0x0,%edx
  80258e:	be 00 00 00 00       	mov    $0x0,%esi
  802593:	bf 0e 00 00 00       	mov    $0xe,%edi
  802598:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
}
  8025a4:	c9                   	leaveq 
  8025a5:	c3                   	retq   

00000000008025a6 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8025a6:	55                   	push   %rbp
  8025a7:	48 89 e5             	mov    %rsp,%rbp
  8025aa:	48 83 ec 20          	sub    $0x20,%rsp
  8025ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025b2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8025b5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8025b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025c3:	00 
  8025c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025d0:	48 89 d1             	mov    %rdx,%rcx
  8025d3:	48 89 c2             	mov    %rax,%rdx
  8025d6:	be 00 00 00 00       	mov    $0x0,%esi
  8025db:	bf 0f 00 00 00       	mov    $0xf,%edi
  8025e0:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax
}
  8025ec:	c9                   	leaveq 
  8025ed:	c3                   	retq   

00000000008025ee <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  8025ee:	55                   	push   %rbp
  8025ef:	48 89 e5             	mov    %rsp,%rbp
  8025f2:	48 83 ec 20          	sub    $0x20,%rsp
  8025f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025fa:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  8025fd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802604:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80260b:	00 
  80260c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802612:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802618:	48 89 d1             	mov    %rdx,%rcx
  80261b:	48 89 c2             	mov    %rax,%rdx
  80261e:	be 00 00 00 00       	mov    $0x0,%esi
  802623:	bf 10 00 00 00       	mov    $0x10,%edi
  802628:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  80262f:	00 00 00 
  802632:	ff d0                	callq  *%rax
}
  802634:	c9                   	leaveq 
  802635:	c3                   	retq   

0000000000802636 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802636:	55                   	push   %rbp
  802637:	48 89 e5             	mov    %rsp,%rbp
  80263a:	48 83 ec 30          	sub    $0x30,%rsp
  80263e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802641:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802645:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802648:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80264c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802650:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802653:	48 63 c8             	movslq %eax,%rcx
  802656:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80265a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80265d:	48 63 f0             	movslq %eax,%rsi
  802660:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802667:	48 98                	cltq   
  802669:	48 89 0c 24          	mov    %rcx,(%rsp)
  80266d:	49 89 f9             	mov    %rdi,%r9
  802670:	49 89 f0             	mov    %rsi,%r8
  802673:	48 89 d1             	mov    %rdx,%rcx
  802676:	48 89 c2             	mov    %rax,%rdx
  802679:	be 00 00 00 00       	mov    $0x0,%esi
  80267e:	bf 11 00 00 00       	mov    $0x11,%edi
  802683:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80268f:	c9                   	leaveq 
  802690:	c3                   	retq   

0000000000802691 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802691:	55                   	push   %rbp
  802692:	48 89 e5             	mov    %rsp,%rbp
  802695:	48 83 ec 20          	sub    $0x20,%rsp
  802699:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80269d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8026a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026a9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8026b0:	00 
  8026b1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026bd:	48 89 d1             	mov    %rdx,%rcx
  8026c0:	48 89 c2             	mov    %rax,%rdx
  8026c3:	be 00 00 00 00       	mov    $0x0,%esi
  8026c8:	bf 12 00 00 00       	mov    $0x12,%edi
  8026cd:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	callq  *%rax
}
  8026d9:	c9                   	leaveq 
  8026da:	c3                   	retq   

00000000008026db <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026db:	55                   	push   %rbp
  8026dc:	48 89 e5             	mov    %rsp,%rbp
  8026df:	48 83 ec 08          	sub    $0x8,%rsp
  8026e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026eb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026f2:	ff ff ff 
  8026f5:	48 01 d0             	add    %rdx,%rax
  8026f8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026fc:	c9                   	leaveq 
  8026fd:	c3                   	retq   

00000000008026fe <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026fe:	55                   	push   %rbp
  8026ff:	48 89 e5             	mov    %rsp,%rbp
  802702:	48 83 ec 08          	sub    $0x8,%rsp
  802706:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80270a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80270e:	48 89 c7             	mov    %rax,%rdi
  802711:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802718:	00 00 00 
  80271b:	ff d0                	callq  *%rax
  80271d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802723:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802727:	c9                   	leaveq 
  802728:	c3                   	retq   

0000000000802729 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802729:	55                   	push   %rbp
  80272a:	48 89 e5             	mov    %rsp,%rbp
  80272d:	48 83 ec 18          	sub    $0x18,%rsp
  802731:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802735:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80273c:	eb 6b                	jmp    8027a9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80273e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802741:	48 98                	cltq   
  802743:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802749:	48 c1 e0 0c          	shl    $0xc,%rax
  80274d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802755:	48 c1 e8 15          	shr    $0x15,%rax
  802759:	48 89 c2             	mov    %rax,%rdx
  80275c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802763:	01 00 00 
  802766:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276a:	83 e0 01             	and    $0x1,%eax
  80276d:	48 85 c0             	test   %rax,%rax
  802770:	74 21                	je     802793 <fd_alloc+0x6a>
  802772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802776:	48 c1 e8 0c          	shr    $0xc,%rax
  80277a:	48 89 c2             	mov    %rax,%rdx
  80277d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802784:	01 00 00 
  802787:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278b:	83 e0 01             	and    $0x1,%eax
  80278e:	48 85 c0             	test   %rax,%rax
  802791:	75 12                	jne    8027a5 <fd_alloc+0x7c>
			*fd_store = fd;
  802793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802797:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80279b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	eb 1a                	jmp    8027bf <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027a9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027ad:	7e 8f                	jle    80273e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027ba:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027bf:	c9                   	leaveq 
  8027c0:	c3                   	retq   

00000000008027c1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027c1:	55                   	push   %rbp
  8027c2:	48 89 e5             	mov    %rsp,%rbp
  8027c5:	48 83 ec 20          	sub    $0x20,%rsp
  8027c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027d4:	78 06                	js     8027dc <fd_lookup+0x1b>
  8027d6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027da:	7e 07                	jle    8027e3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027e1:	eb 6c                	jmp    80284f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e6:	48 98                	cltq   
  8027e8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027ee:	48 c1 e0 0c          	shl    $0xc,%rax
  8027f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fa:	48 c1 e8 15          	shr    $0x15,%rax
  8027fe:	48 89 c2             	mov    %rax,%rdx
  802801:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802808:	01 00 00 
  80280b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280f:	83 e0 01             	and    $0x1,%eax
  802812:	48 85 c0             	test   %rax,%rax
  802815:	74 21                	je     802838 <fd_lookup+0x77>
  802817:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80281b:	48 c1 e8 0c          	shr    $0xc,%rax
  80281f:	48 89 c2             	mov    %rax,%rdx
  802822:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802829:	01 00 00 
  80282c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802830:	83 e0 01             	and    $0x1,%eax
  802833:	48 85 c0             	test   %rax,%rax
  802836:	75 07                	jne    80283f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802838:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80283d:	eb 10                	jmp    80284f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80283f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802843:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802847:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80284a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284f:	c9                   	leaveq 
  802850:	c3                   	retq   

0000000000802851 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802851:	55                   	push   %rbp
  802852:	48 89 e5             	mov    %rsp,%rbp
  802855:	48 83 ec 30          	sub    $0x30,%rsp
  802859:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80285d:	89 f0                	mov    %esi,%eax
  80285f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802866:	48 89 c7             	mov    %rax,%rdi
  802869:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  802870:	00 00 00 
  802873:	ff d0                	callq  *%rax
  802875:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802879:	48 89 d6             	mov    %rdx,%rsi
  80287c:	89 c7                	mov    %eax,%edi
  80287e:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
  80288a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802891:	78 0a                	js     80289d <fd_close+0x4c>
	    || fd != fd2)
  802893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802897:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80289b:	74 12                	je     8028af <fd_close+0x5e>
		return (must_exist ? r : 0);
  80289d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8028a1:	74 05                	je     8028a8 <fd_close+0x57>
  8028a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a6:	eb 05                	jmp    8028ad <fd_close+0x5c>
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ad:	eb 69                	jmp    802918 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b3:	8b 00                	mov    (%rax),%eax
  8028b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b9:	48 89 d6             	mov    %rdx,%rsi
  8028bc:	89 c7                	mov    %eax,%edi
  8028be:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	callq  *%rax
  8028ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d1:	78 2a                	js     8028fd <fd_close+0xac>
		if (dev->dev_close)
  8028d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028db:	48 85 c0             	test   %rax,%rax
  8028de:	74 16                	je     8028f6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ec:	48 89 d7             	mov    %rdx,%rdi
  8028ef:	ff d0                	callq  *%rax
  8028f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f4:	eb 07                	jmp    8028fd <fd_close+0xac>
		else
			r = 0;
  8028f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802901:	48 89 c6             	mov    %rax,%rsi
  802904:	bf 00 00 00 00       	mov    $0x0,%edi
  802909:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
	return r;
  802915:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802918:	c9                   	leaveq 
  802919:	c3                   	retq   

000000000080291a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80291a:	55                   	push   %rbp
  80291b:	48 89 e5             	mov    %rsp,%rbp
  80291e:	48 83 ec 20          	sub    $0x20,%rsp
  802922:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802925:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802929:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802930:	eb 41                	jmp    802973 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802932:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802939:	00 00 00 
  80293c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80293f:	48 63 d2             	movslq %edx,%rdx
  802942:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802946:	8b 00                	mov    (%rax),%eax
  802948:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80294b:	75 22                	jne    80296f <dev_lookup+0x55>
			*dev = devtab[i];
  80294d:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802954:	00 00 00 
  802957:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80295a:	48 63 d2             	movslq %edx,%rdx
  80295d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802961:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802965:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802968:	b8 00 00 00 00       	mov    $0x0,%eax
  80296d:	eb 60                	jmp    8029cf <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80296f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802973:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80297a:	00 00 00 
  80297d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802980:	48 63 d2             	movslq %edx,%rdx
  802983:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802987:	48 85 c0             	test   %rax,%rax
  80298a:	75 a6                	jne    802932 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80298c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802993:	00 00 00 
  802996:	48 8b 00             	mov    (%rax),%rax
  802999:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80299f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8029a2:	89 c6                	mov    %eax,%esi
  8029a4:	48 bf 18 5d 80 00 00 	movabs $0x805d18,%rdi
  8029ab:	00 00 00 
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b3:	48 b9 17 0e 80 00 00 	movabs $0x800e17,%rcx
  8029ba:	00 00 00 
  8029bd:	ff d1                	callq  *%rcx
	*dev = 0;
  8029bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029cf:	c9                   	leaveq 
  8029d0:	c3                   	retq   

00000000008029d1 <close>:

int
close(int fdnum)
{
  8029d1:	55                   	push   %rbp
  8029d2:	48 89 e5             	mov    %rsp,%rbp
  8029d5:	48 83 ec 20          	sub    $0x20,%rsp
  8029d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029e3:	48 89 d6             	mov    %rdx,%rsi
  8029e6:	89 c7                	mov    %eax,%edi
  8029e8:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  8029ef:	00 00 00 
  8029f2:	ff d0                	callq  *%rax
  8029f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fb:	79 05                	jns    802a02 <close+0x31>
		return r;
  8029fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a00:	eb 18                	jmp    802a1a <close+0x49>
	else
		return fd_close(fd, 1);
  802a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a06:	be 01 00 00 00       	mov    $0x1,%esi
  802a0b:	48 89 c7             	mov    %rax,%rdi
  802a0e:	48 b8 51 28 80 00 00 	movabs $0x802851,%rax
  802a15:	00 00 00 
  802a18:	ff d0                	callq  *%rax
}
  802a1a:	c9                   	leaveq 
  802a1b:	c3                   	retq   

0000000000802a1c <close_all>:

void
close_all(void)
{
  802a1c:	55                   	push   %rbp
  802a1d:	48 89 e5             	mov    %rsp,%rbp
  802a20:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a2b:	eb 15                	jmp    802a42 <close_all+0x26>
		close(i);
  802a2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a30:	89 c7                	mov    %eax,%edi
  802a32:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  802a39:	00 00 00 
  802a3c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a3e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a42:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a46:	7e e5                	jle    802a2d <close_all+0x11>
		close(i);
}
  802a48:	c9                   	leaveq 
  802a49:	c3                   	retq   

0000000000802a4a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a4a:	55                   	push   %rbp
  802a4b:	48 89 e5             	mov    %rsp,%rbp
  802a4e:	48 83 ec 40          	sub    $0x40,%rsp
  802a52:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a55:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a58:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a5c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a5f:	48 89 d6             	mov    %rdx,%rsi
  802a62:	89 c7                	mov    %eax,%edi
  802a64:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802a6b:	00 00 00 
  802a6e:	ff d0                	callq  *%rax
  802a70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a77:	79 08                	jns    802a81 <dup+0x37>
		return r;
  802a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7c:	e9 70 01 00 00       	jmpq   802bf1 <dup+0x1a7>
	close(newfdnum);
  802a81:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a84:	89 c7                	mov    %eax,%edi
  802a86:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a92:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a95:	48 98                	cltq   
  802a97:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a9d:	48 c1 e0 0c          	shl    $0xc,%rax
  802aa1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa9:	48 89 c7             	mov    %rax,%rdi
  802aac:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  802ab3:	00 00 00 
  802ab6:	ff d0                	callq  *%rax
  802ab8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802abc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac0:	48 89 c7             	mov    %rax,%rdi
  802ac3:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
  802acf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad7:	48 c1 e8 15          	shr    $0x15,%rax
  802adb:	48 89 c2             	mov    %rax,%rdx
  802ade:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ae5:	01 00 00 
  802ae8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aec:	83 e0 01             	and    $0x1,%eax
  802aef:	48 85 c0             	test   %rax,%rax
  802af2:	74 73                	je     802b67 <dup+0x11d>
  802af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af8:	48 c1 e8 0c          	shr    $0xc,%rax
  802afc:	48 89 c2             	mov    %rax,%rdx
  802aff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b06:	01 00 00 
  802b09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b0d:	83 e0 01             	and    $0x1,%eax
  802b10:	48 85 c0             	test   %rax,%rax
  802b13:	74 52                	je     802b67 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b19:	48 c1 e8 0c          	shr    $0xc,%rax
  802b1d:	48 89 c2             	mov    %rax,%rdx
  802b20:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b27:	01 00 00 
  802b2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b2e:	25 07 0e 00 00       	and    $0xe07,%eax
  802b33:	89 c1                	mov    %eax,%ecx
  802b35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3d:	41 89 c8             	mov    %ecx,%r8d
  802b40:	48 89 d1             	mov    %rdx,%rcx
  802b43:	ba 00 00 00 00       	mov    $0x0,%edx
  802b48:	48 89 c6             	mov    %rax,%rsi
  802b4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b50:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
  802b5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b63:	79 02                	jns    802b67 <dup+0x11d>
			goto err;
  802b65:	eb 57                	jmp    802bbe <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b6b:	48 c1 e8 0c          	shr    $0xc,%rax
  802b6f:	48 89 c2             	mov    %rax,%rdx
  802b72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b79:	01 00 00 
  802b7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b80:	25 07 0e 00 00       	and    $0xe07,%eax
  802b85:	89 c1                	mov    %eax,%ecx
  802b87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b8f:	41 89 c8             	mov    %ecx,%r8d
  802b92:	48 89 d1             	mov    %rdx,%rcx
  802b95:	ba 00 00 00 00       	mov    $0x0,%edx
  802b9a:	48 89 c6             	mov    %rax,%rsi
  802b9d:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba2:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  802ba9:	00 00 00 
  802bac:	ff d0                	callq  *%rax
  802bae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb5:	79 02                	jns    802bb9 <dup+0x16f>
		goto err;
  802bb7:	eb 05                	jmp    802bbe <dup+0x174>

	return newfdnum;
  802bb9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bbc:	eb 33                	jmp    802bf1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc2:	48 89 c6             	mov    %rax,%rsi
  802bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bca:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bda:	48 89 c6             	mov    %rax,%rsi
  802bdd:	bf 00 00 00 00       	mov    $0x0,%edi
  802be2:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax
	return r;
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bf1:	c9                   	leaveq 
  802bf2:	c3                   	retq   

0000000000802bf3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bf3:	55                   	push   %rbp
  802bf4:	48 89 e5             	mov    %rsp,%rbp
  802bf7:	48 83 ec 40          	sub    $0x40,%rsp
  802bfb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bfe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c02:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c0d:	48 89 d6             	mov    %rdx,%rsi
  802c10:	89 c7                	mov    %eax,%edi
  802c12:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
  802c1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c25:	78 24                	js     802c4b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2b:	8b 00                	mov    (%rax),%eax
  802c2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c31:	48 89 d6             	mov    %rdx,%rsi
  802c34:	89 c7                	mov    %eax,%edi
  802c36:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
  802c42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c49:	79 05                	jns    802c50 <read+0x5d>
		return r;
  802c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4e:	eb 76                	jmp    802cc6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c54:	8b 40 08             	mov    0x8(%rax),%eax
  802c57:	83 e0 03             	and    $0x3,%eax
  802c5a:	83 f8 01             	cmp    $0x1,%eax
  802c5d:	75 3a                	jne    802c99 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c5f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802c66:	00 00 00 
  802c69:	48 8b 00             	mov    (%rax),%rax
  802c6c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c72:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c75:	89 c6                	mov    %eax,%esi
  802c77:	48 bf 37 5d 80 00 00 	movabs $0x805d37,%rdi
  802c7e:	00 00 00 
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	48 b9 17 0e 80 00 00 	movabs $0x800e17,%rcx
  802c8d:	00 00 00 
  802c90:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c97:	eb 2d                	jmp    802cc6 <read+0xd3>
	}
	if (!dev->dev_read)
  802c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ca1:	48 85 c0             	test   %rax,%rax
  802ca4:	75 07                	jne    802cad <read+0xba>
		return -E_NOT_SUPP;
  802ca6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cab:	eb 19                	jmp    802cc6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb1:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cb5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cbd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cc1:	48 89 cf             	mov    %rcx,%rdi
  802cc4:	ff d0                	callq  *%rax
}
  802cc6:	c9                   	leaveq 
  802cc7:	c3                   	retq   

0000000000802cc8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cc8:	55                   	push   %rbp
  802cc9:	48 89 e5             	mov    %rsp,%rbp
  802ccc:	48 83 ec 30          	sub    $0x30,%rsp
  802cd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ce2:	eb 49                	jmp    802d2d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce7:	48 98                	cltq   
  802ce9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ced:	48 29 c2             	sub    %rax,%rdx
  802cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf3:	48 63 c8             	movslq %eax,%rcx
  802cf6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cfa:	48 01 c1             	add    %rax,%rcx
  802cfd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d00:	48 89 ce             	mov    %rcx,%rsi
  802d03:	89 c7                	mov    %eax,%edi
  802d05:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
  802d11:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d14:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d18:	79 05                	jns    802d1f <readn+0x57>
			return m;
  802d1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d1d:	eb 1c                	jmp    802d3b <readn+0x73>
		if (m == 0)
  802d1f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d23:	75 02                	jne    802d27 <readn+0x5f>
			break;
  802d25:	eb 11                	jmp    802d38 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d2a:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d30:	48 98                	cltq   
  802d32:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d36:	72 ac                	jb     802ce4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d3b:	c9                   	leaveq 
  802d3c:	c3                   	retq   

0000000000802d3d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d3d:	55                   	push   %rbp
  802d3e:	48 89 e5             	mov    %rsp,%rbp
  802d41:	48 83 ec 40          	sub    $0x40,%rsp
  802d45:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d48:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d4c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d57:	48 89 d6             	mov    %rdx,%rsi
  802d5a:	89 c7                	mov    %eax,%edi
  802d5c:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
  802d68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6f:	78 24                	js     802d95 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d75:	8b 00                	mov    (%rax),%eax
  802d77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d7b:	48 89 d6             	mov    %rdx,%rsi
  802d7e:	89 c7                	mov    %eax,%edi
  802d80:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
  802d8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d93:	79 05                	jns    802d9a <write+0x5d>
		return r;
  802d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d98:	eb 75                	jmp    802e0f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9e:	8b 40 08             	mov    0x8(%rax),%eax
  802da1:	83 e0 03             	and    $0x3,%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	75 3a                	jne    802de2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802da8:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802daf:	00 00 00 
  802db2:	48 8b 00             	mov    (%rax),%rax
  802db5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dbb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dbe:	89 c6                	mov    %eax,%esi
  802dc0:	48 bf 53 5d 80 00 00 	movabs $0x805d53,%rdi
  802dc7:	00 00 00 
  802dca:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcf:	48 b9 17 0e 80 00 00 	movabs $0x800e17,%rcx
  802dd6:	00 00 00 
  802dd9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ddb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802de0:	eb 2d                	jmp    802e0f <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dea:	48 85 c0             	test   %rax,%rax
  802ded:	75 07                	jne    802df6 <write+0xb9>
		return -E_NOT_SUPP;
  802def:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802df4:	eb 19                	jmp    802e0f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfa:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dfe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e02:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e06:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e0a:	48 89 cf             	mov    %rcx,%rdi
  802e0d:	ff d0                	callq  *%rax
}
  802e0f:	c9                   	leaveq 
  802e10:	c3                   	retq   

0000000000802e11 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e11:	55                   	push   %rbp
  802e12:	48 89 e5             	mov    %rsp,%rbp
  802e15:	48 83 ec 18          	sub    $0x18,%rsp
  802e19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e1c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e26:	48 89 d6             	mov    %rdx,%rsi
  802e29:	89 c7                	mov    %eax,%edi
  802e2b:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
  802e37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3e:	79 05                	jns    802e45 <seek+0x34>
		return r;
  802e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e43:	eb 0f                	jmp    802e54 <seek+0x43>
	fd->fd_offset = offset;
  802e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e49:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e54:	c9                   	leaveq 
  802e55:	c3                   	retq   

0000000000802e56 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e56:	55                   	push   %rbp
  802e57:	48 89 e5             	mov    %rsp,%rbp
  802e5a:	48 83 ec 30          	sub    $0x30,%rsp
  802e5e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e61:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e6b:	48 89 d6             	mov    %rdx,%rsi
  802e6e:	89 c7                	mov    %eax,%edi
  802e70:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
  802e7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e83:	78 24                	js     802ea9 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e89:	8b 00                	mov    (%rax),%eax
  802e8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e8f:	48 89 d6             	mov    %rdx,%rsi
  802e92:	89 c7                	mov    %eax,%edi
  802e94:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea7:	79 05                	jns    802eae <ftruncate+0x58>
		return r;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	eb 72                	jmp    802f20 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb2:	8b 40 08             	mov    0x8(%rax),%eax
  802eb5:	83 e0 03             	and    $0x3,%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	75 3a                	jne    802ef6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ebc:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802ec3:	00 00 00 
  802ec6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ec9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ecf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ed2:	89 c6                	mov    %eax,%esi
  802ed4:	48 bf 70 5d 80 00 00 	movabs $0x805d70,%rdi
  802edb:	00 00 00 
  802ede:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee3:	48 b9 17 0e 80 00 00 	movabs $0x800e17,%rcx
  802eea:	00 00 00 
  802eed:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef4:	eb 2a                	jmp    802f20 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efa:	48 8b 40 30          	mov    0x30(%rax),%rax
  802efe:	48 85 c0             	test   %rax,%rax
  802f01:	75 07                	jne    802f0a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f08:	eb 16                	jmp    802f20 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f16:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f19:	89 ce                	mov    %ecx,%esi
  802f1b:	48 89 d7             	mov    %rdx,%rdi
  802f1e:	ff d0                	callq  *%rax
}
  802f20:	c9                   	leaveq 
  802f21:	c3                   	retq   

0000000000802f22 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f22:	55                   	push   %rbp
  802f23:	48 89 e5             	mov    %rsp,%rbp
  802f26:	48 83 ec 30          	sub    $0x30,%rsp
  802f2a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f2d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f31:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f35:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f38:	48 89 d6             	mov    %rdx,%rsi
  802f3b:	89 c7                	mov    %eax,%edi
  802f3d:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  802f44:	00 00 00 
  802f47:	ff d0                	callq  *%rax
  802f49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f50:	78 24                	js     802f76 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f56:	8b 00                	mov    (%rax),%eax
  802f58:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f5c:	48 89 d6             	mov    %rdx,%rsi
  802f5f:	89 c7                	mov    %eax,%edi
  802f61:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	callq  *%rax
  802f6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f74:	79 05                	jns    802f7b <fstat+0x59>
		return r;
  802f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f79:	eb 5e                	jmp    802fd9 <fstat+0xb7>
	if (!dev->dev_stat)
  802f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f83:	48 85 c0             	test   %rax,%rax
  802f86:	75 07                	jne    802f8f <fstat+0x6d>
		return -E_NOT_SUPP;
  802f88:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f8d:	eb 4a                	jmp    802fd9 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f93:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f9a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802fa1:	00 00 00 
	stat->st_isdir = 0;
  802fa4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802faf:	00 00 00 
	stat->st_dev = dev;
  802fb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fba:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc5:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fcd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fd1:	48 89 ce             	mov    %rcx,%rsi
  802fd4:	48 89 d7             	mov    %rdx,%rdi
  802fd7:	ff d0                	callq  *%rax
}
  802fd9:	c9                   	leaveq 
  802fda:	c3                   	retq   

0000000000802fdb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fdb:	55                   	push   %rbp
  802fdc:	48 89 e5             	mov    %rsp,%rbp
  802fdf:	48 83 ec 20          	sub    $0x20,%rsp
  802fe3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fe7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fef:	be 00 00 00 00       	mov    $0x0,%esi
  802ff4:	48 89 c7             	mov    %rax,%rdi
  802ff7:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  802ffe:	00 00 00 
  803001:	ff d0                	callq  *%rax
  803003:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803006:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300a:	79 05                	jns    803011 <stat+0x36>
		return fd;
  80300c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300f:	eb 2f                	jmp    803040 <stat+0x65>
	r = fstat(fd, stat);
  803011:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803018:	48 89 d6             	mov    %rdx,%rsi
  80301b:	89 c7                	mov    %eax,%edi
  80301d:	48 b8 22 2f 80 00 00 	movabs $0x802f22,%rax
  803024:	00 00 00 
  803027:	ff d0                	callq  *%rax
  803029:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80302c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302f:	89 c7                	mov    %eax,%edi
  803031:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
	return r;
  80303d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803040:	c9                   	leaveq 
  803041:	c3                   	retq   

0000000000803042 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803042:	55                   	push   %rbp
  803043:	48 89 e5             	mov    %rsp,%rbp
  803046:	48 83 ec 10          	sub    $0x10,%rsp
  80304a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80304d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803051:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803058:	00 00 00 
  80305b:	8b 00                	mov    (%rax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	75 1d                	jne    80307e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803061:	bf 01 00 00 00       	mov    $0x1,%edi
  803066:	48 b8 e5 4f 80 00 00 	movabs $0x804fe5,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803079:	00 00 00 
  80307c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80307e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803085:	00 00 00 
  803088:	8b 00                	mov    (%rax),%eax
  80308a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80308d:	b9 07 00 00 00       	mov    $0x7,%ecx
  803092:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803099:	00 00 00 
  80309c:	89 c7                	mov    %eax,%edi
  80309e:	48 b8 d9 4d 80 00 00 	movabs $0x804dd9,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8030b3:	48 89 c6             	mov    %rax,%rsi
  8030b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8030bb:	48 b8 18 4d 80 00 00 	movabs $0x804d18,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
}
  8030c7:	c9                   	leaveq 
  8030c8:	c3                   	retq   

00000000008030c9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030c9:	55                   	push   %rbp
  8030ca:	48 89 e5             	mov    %rsp,%rbp
  8030cd:	48 83 ec 20          	sub    $0x20,%rsp
  8030d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030d5:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8030d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030dc:	48 89 c7             	mov    %rax,%rdi
  8030df:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
  8030eb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030f0:	7e 0a                	jle    8030fc <open+0x33>
		return -E_BAD_PATH;
  8030f2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030f7:	e9 a5 00 00 00       	jmpq   8031a1 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8030fc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803100:	48 89 c7             	mov    %rax,%rdi
  803103:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  80310a:	00 00 00 
  80310d:	ff d0                	callq  *%rax
  80310f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803112:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803116:	79 08                	jns    803120 <open+0x57>
		return r;
  803118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311b:	e9 81 00 00 00       	jmpq   8031a1 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803124:	48 89 c6             	mov    %rax,%rsi
  803127:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  80312e:	00 00 00 
  803131:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80313d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803144:	00 00 00 
  803147:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80314a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803154:	48 89 c6             	mov    %rax,%rsi
  803157:	bf 01 00 00 00       	mov    $0x1,%edi
  80315c:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803163:	00 00 00 
  803166:	ff d0                	callq  *%rax
  803168:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80316b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316f:	79 1d                	jns    80318e <open+0xc5>
		fd_close(fd, 0);
  803171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803175:	be 00 00 00 00       	mov    $0x0,%esi
  80317a:	48 89 c7             	mov    %rax,%rdi
  80317d:	48 b8 51 28 80 00 00 	movabs $0x802851,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
		return r;
  803189:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318c:	eb 13                	jmp    8031a1 <open+0xd8>
	}

	return fd2num(fd);
  80318e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803192:	48 89 c7             	mov    %rax,%rdi
  803195:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  80319c:	00 00 00 
  80319f:	ff d0                	callq  *%rax

}
  8031a1:	c9                   	leaveq 
  8031a2:	c3                   	retq   

00000000008031a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8031a3:	55                   	push   %rbp
  8031a4:	48 89 e5             	mov    %rsp,%rbp
  8031a7:	48 83 ec 10          	sub    $0x10,%rsp
  8031ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b3:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bd:	00 00 00 
  8031c0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031c2:	be 00 00 00 00       	mov    $0x0,%esi
  8031c7:	bf 06 00 00 00       	mov    $0x6,%edi
  8031cc:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
}
  8031d8:	c9                   	leaveq 
  8031d9:	c3                   	retq   

00000000008031da <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031da:	55                   	push   %rbp
  8031db:	48 89 e5             	mov    %rsp,%rbp
  8031de:	48 83 ec 30          	sub    $0x30,%rsp
  8031e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f2:	8b 50 0c             	mov    0xc(%rax),%edx
  8031f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031fc:	00 00 00 
  8031ff:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803201:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803208:	00 00 00 
  80320b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80320f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803213:	be 00 00 00 00       	mov    $0x0,%esi
  803218:	bf 03 00 00 00       	mov    $0x3,%edi
  80321d:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
  803229:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80322c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803230:	79 08                	jns    80323a <devfile_read+0x60>
		return r;
  803232:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803235:	e9 a4 00 00 00       	jmpq   8032de <devfile_read+0x104>
	assert(r <= n);
  80323a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323d:	48 98                	cltq   
  80323f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803243:	76 35                	jbe    80327a <devfile_read+0xa0>
  803245:	48 b9 96 5d 80 00 00 	movabs $0x805d96,%rcx
  80324c:	00 00 00 
  80324f:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  803256:	00 00 00 
  803259:	be 86 00 00 00       	mov    $0x86,%esi
  80325e:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  803265:	00 00 00 
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
  80326d:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  803274:	00 00 00 
  803277:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80327a:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803281:	7e 35                	jle    8032b8 <devfile_read+0xde>
  803283:	48 b9 bd 5d 80 00 00 	movabs $0x805dbd,%rcx
  80328a:	00 00 00 
  80328d:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  803294:	00 00 00 
  803297:	be 87 00 00 00       	mov    $0x87,%esi
  80329c:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  8032a3:	00 00 00 
  8032a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ab:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  8032b2:	00 00 00 
  8032b5:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8032b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bb:	48 63 d0             	movslq %eax,%rdx
  8032be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c2:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8032c9:	00 00 00 
  8032cc:	48 89 c7             	mov    %rax,%rdi
  8032cf:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
	return r;
  8032db:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8032de:	c9                   	leaveq 
  8032df:	c3                   	retq   

00000000008032e0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8032e0:	55                   	push   %rbp
  8032e1:	48 89 e5             	mov    %rsp,%rbp
  8032e4:	48 83 ec 40          	sub    $0x40,%rsp
  8032e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8032f4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8032fc:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803303:	00 
  803304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803308:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80330c:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803311:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803319:	8b 50 0c             	mov    0xc(%rax),%edx
  80331c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803323:	00 00 00 
  803326:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803328:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80332f:	00 00 00 
  803332:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803336:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80333a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80333e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803342:	48 89 c6             	mov    %rax,%rsi
  803345:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  80334c:	00 00 00 
  80334f:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80335b:	be 00 00 00 00       	mov    $0x0,%esi
  803360:	bf 04 00 00 00       	mov    $0x4,%edi
  803365:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803374:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803378:	79 05                	jns    80337f <devfile_write+0x9f>
		return r;
  80337a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80337d:	eb 43                	jmp    8033c2 <devfile_write+0xe2>
	assert(r <= n);
  80337f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803382:	48 98                	cltq   
  803384:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803388:	76 35                	jbe    8033bf <devfile_write+0xdf>
  80338a:	48 b9 96 5d 80 00 00 	movabs $0x805d96,%rcx
  803391:	00 00 00 
  803394:	48 ba 9d 5d 80 00 00 	movabs $0x805d9d,%rdx
  80339b:	00 00 00 
  80339e:	be a2 00 00 00       	mov    $0xa2,%esi
  8033a3:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  8033aa:	00 00 00 
  8033ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b2:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  8033b9:	00 00 00 
  8033bc:	41 ff d0             	callq  *%r8
	return r;
  8033bf:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8033c2:	c9                   	leaveq 
  8033c3:	c3                   	retq   

00000000008033c4 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033c4:	55                   	push   %rbp
  8033c5:	48 89 e5             	mov    %rsp,%rbp
  8033c8:	48 83 ec 20          	sub    $0x20,%rsp
  8033cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8033db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033e2:	00 00 00 
  8033e5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033e7:	be 00 00 00 00       	mov    $0x0,%esi
  8033ec:	bf 05 00 00 00       	mov    $0x5,%edi
  8033f1:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8033f8:	00 00 00 
  8033fb:	ff d0                	callq  *%rax
  8033fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803400:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803404:	79 05                	jns    80340b <devfile_stat+0x47>
		return r;
  803406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803409:	eb 56                	jmp    803461 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80340b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80340f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803416:	00 00 00 
  803419:	48 89 c7             	mov    %rax,%rdi
  80341c:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803428:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342f:	00 00 00 
  803432:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803438:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80343c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803442:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803449:	00 00 00 
  80344c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803452:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803456:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80345c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803461:	c9                   	leaveq 
  803462:	c3                   	retq   

0000000000803463 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803463:	55                   	push   %rbp
  803464:	48 89 e5             	mov    %rsp,%rbp
  803467:	48 83 ec 10          	sub    $0x10,%rsp
  80346b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80346f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803476:	8b 50 0c             	mov    0xc(%rax),%edx
  803479:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803480:	00 00 00 
  803483:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803485:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80348c:	00 00 00 
  80348f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803492:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803495:	be 00 00 00 00       	mov    $0x0,%esi
  80349a:	bf 02 00 00 00       	mov    $0x2,%edi
  80349f:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8034a6:	00 00 00 
  8034a9:	ff d0                	callq  *%rax
}
  8034ab:	c9                   	leaveq 
  8034ac:	c3                   	retq   

00000000008034ad <remove>:

// Delete a file
int
remove(const char *path)
{
  8034ad:	55                   	push   %rbp
  8034ae:	48 89 e5             	mov    %rsp,%rbp
  8034b1:	48 83 ec 10          	sub    $0x10,%rsp
  8034b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8034b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bd:	48 89 c7             	mov    %rax,%rdi
  8034c0:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
  8034cc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034d1:	7e 07                	jle    8034da <remove+0x2d>
		return -E_BAD_PATH;
  8034d3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034d8:	eb 33                	jmp    80350d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034de:	48 89 c6             	mov    %rax,%rsi
  8034e1:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8034e8:	00 00 00 
  8034eb:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8034f2:	00 00 00 
  8034f5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034f7:	be 00 00 00 00       	mov    $0x0,%esi
  8034fc:	bf 07 00 00 00       	mov    $0x7,%edi
  803501:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803508:	00 00 00 
  80350b:	ff d0                	callq  *%rax
}
  80350d:	c9                   	leaveq 
  80350e:	c3                   	retq   

000000000080350f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80350f:	55                   	push   %rbp
  803510:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803513:	be 00 00 00 00       	mov    $0x0,%esi
  803518:	bf 08 00 00 00       	mov    $0x8,%edi
  80351d:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803524:	00 00 00 
  803527:	ff d0                	callq  *%rax
}
  803529:	5d                   	pop    %rbp
  80352a:	c3                   	retq   

000000000080352b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80352b:	55                   	push   %rbp
  80352c:	48 89 e5             	mov    %rsp,%rbp
  80352f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803536:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80353d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803544:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80354b:	be 00 00 00 00       	mov    $0x0,%esi
  803550:	48 89 c7             	mov    %rax,%rdi
  803553:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
  80355f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803566:	79 28                	jns    803590 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356b:	89 c6                	mov    %eax,%esi
  80356d:	48 bf c9 5d 80 00 00 	movabs $0x805dc9,%rdi
  803574:	00 00 00 
  803577:	b8 00 00 00 00       	mov    $0x0,%eax
  80357c:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  803583:	00 00 00 
  803586:	ff d2                	callq  *%rdx
		return fd_src;
  803588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358b:	e9 74 01 00 00       	jmpq   803704 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803590:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803597:	be 01 01 00 00       	mov    $0x101,%esi
  80359c:	48 89 c7             	mov    %rax,%rdi
  80359f:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  8035a6:	00 00 00 
  8035a9:	ff d0                	callq  *%rax
  8035ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8035ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035b2:	79 39                	jns    8035ed <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8035b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035b7:	89 c6                	mov    %eax,%esi
  8035b9:	48 bf df 5d 80 00 00 	movabs $0x805ddf,%rdi
  8035c0:	00 00 00 
  8035c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c8:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  8035cf:	00 00 00 
  8035d2:	ff d2                	callq  *%rdx
		close(fd_src);
  8035d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d7:	89 c7                	mov    %eax,%edi
  8035d9:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
		return fd_dest;
  8035e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e8:	e9 17 01 00 00       	jmpq   803704 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035ed:	eb 74                	jmp    803663 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8035ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035f2:	48 63 d0             	movslq %eax,%rdx
  8035f5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ff:	48 89 ce             	mov    %rcx,%rsi
  803602:	89 c7                	mov    %eax,%edi
  803604:	48 b8 3d 2d 80 00 00 	movabs $0x802d3d,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
  803610:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803613:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803617:	79 4a                	jns    803663 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803619:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80361c:	89 c6                	mov    %eax,%esi
  80361e:	48 bf f9 5d 80 00 00 	movabs $0x805df9,%rdi
  803625:	00 00 00 
  803628:	b8 00 00 00 00       	mov    $0x0,%eax
  80362d:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  803634:	00 00 00 
  803637:	ff d2                	callq  *%rdx
			close(fd_src);
  803639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363c:	89 c7                	mov    %eax,%edi
  80363e:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
			close(fd_dest);
  80364a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80364d:	89 c7                	mov    %eax,%edi
  80364f:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  803656:	00 00 00 
  803659:	ff d0                	callq  *%rax
			return write_size;
  80365b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80365e:	e9 a1 00 00 00       	jmpq   803704 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803663:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80366a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366d:	ba 00 02 00 00       	mov    $0x200,%edx
  803672:	48 89 ce             	mov    %rcx,%rsi
  803675:	89 c7                	mov    %eax,%edi
  803677:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
  803683:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803686:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80368a:	0f 8f 5f ff ff ff    	jg     8035ef <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803690:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803694:	79 47                	jns    8036dd <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803696:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803699:	89 c6                	mov    %eax,%esi
  80369b:	48 bf 0c 5e 80 00 00 	movabs $0x805e0c,%rdi
  8036a2:	00 00 00 
  8036a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036aa:	48 ba 17 0e 80 00 00 	movabs $0x800e17,%rdx
  8036b1:	00 00 00 
  8036b4:	ff d2                	callq  *%rdx
		close(fd_src);
  8036b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b9:	89 c7                	mov    %eax,%edi
  8036bb:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8036c2:	00 00 00 
  8036c5:	ff d0                	callq  *%rax
		close(fd_dest);
  8036c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ca:	89 c7                	mov    %eax,%edi
  8036cc:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
		return read_size;
  8036d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036db:	eb 27                	jmp    803704 <copy+0x1d9>
	}
	close(fd_src);
  8036dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e0:	89 c7                	mov    %eax,%edi
  8036e2:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8036e9:	00 00 00 
  8036ec:	ff d0                	callq  *%rax
	close(fd_dest);
  8036ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036f1:	89 c7                	mov    %eax,%edi
  8036f3:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
	return 0;
  8036ff:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803704:	c9                   	leaveq 
  803705:	c3                   	retq   

0000000000803706 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803706:	55                   	push   %rbp
  803707:	48 89 e5             	mov    %rsp,%rbp
  80370a:	48 83 ec 20          	sub    $0x20,%rsp
  80370e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803711:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803715:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803718:	48 89 d6             	mov    %rdx,%rsi
  80371b:	89 c7                	mov    %eax,%edi
  80371d:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803730:	79 05                	jns    803737 <fd2sockid+0x31>
		return r;
  803732:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803735:	eb 24                	jmp    80375b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373b:	8b 10                	mov    (%rax),%edx
  80373d:	48 b8 e0 80 80 00 00 	movabs $0x8080e0,%rax
  803744:	00 00 00 
  803747:	8b 00                	mov    (%rax),%eax
  803749:	39 c2                	cmp    %eax,%edx
  80374b:	74 07                	je     803754 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80374d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803752:	eb 07                	jmp    80375b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803758:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80375b:	c9                   	leaveq 
  80375c:	c3                   	retq   

000000000080375d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80375d:	55                   	push   %rbp
  80375e:	48 89 e5             	mov    %rsp,%rbp
  803761:	48 83 ec 20          	sub    $0x20,%rsp
  803765:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803768:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80376c:	48 89 c7             	mov    %rax,%rdi
  80376f:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
  80377b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803782:	78 26                	js     8037aa <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803788:	ba 07 04 00 00       	mov    $0x407,%edx
  80378d:	48 89 c6             	mov    %rax,%rsi
  803790:	bf 00 00 00 00       	mov    $0x0,%edi
  803795:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a8:	79 16                	jns    8037c0 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8037aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ad:	89 c7                	mov    %eax,%edi
  8037af:	48 b8 6a 3c 80 00 00 	movabs $0x803c6a,%rax
  8037b6:	00 00 00 
  8037b9:	ff d0                	callq  *%rax
		return r;
  8037bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037be:	eb 3a                	jmp    8037fa <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c4:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  8037cb:	00 00 00 
  8037ce:	8b 12                	mov    (%rdx),%edx
  8037d0:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8037d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8037dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037e4:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8037e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037eb:	48 89 c7             	mov    %rax,%rdi
  8037ee:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
}
  8037fa:	c9                   	leaveq 
  8037fb:	c3                   	retq   

00000000008037fc <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037fc:	55                   	push   %rbp
  8037fd:	48 89 e5             	mov    %rsp,%rbp
  803800:	48 83 ec 30          	sub    $0x30,%rsp
  803804:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803807:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80380b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80380f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803812:	89 c7                	mov    %eax,%edi
  803814:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  80381b:	00 00 00 
  80381e:	ff d0                	callq  *%rax
  803820:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803823:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803827:	79 05                	jns    80382e <accept+0x32>
		return r;
  803829:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382c:	eb 3b                	jmp    803869 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80382e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803832:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803836:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803839:	48 89 ce             	mov    %rcx,%rsi
  80383c:	89 c7                	mov    %eax,%edi
  80383e:	48 b8 47 3b 80 00 00 	movabs $0x803b47,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
  80384a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80384d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803851:	79 05                	jns    803858 <accept+0x5c>
		return r;
  803853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803856:	eb 11                	jmp    803869 <accept+0x6d>
	return alloc_sockfd(r);
  803858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385b:	89 c7                	mov    %eax,%edi
  80385d:	48 b8 5d 37 80 00 00 	movabs $0x80375d,%rax
  803864:	00 00 00 
  803867:	ff d0                	callq  *%rax
}
  803869:	c9                   	leaveq 
  80386a:	c3                   	retq   

000000000080386b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80386b:	55                   	push   %rbp
  80386c:	48 89 e5             	mov    %rsp,%rbp
  80386f:	48 83 ec 20          	sub    $0x20,%rsp
  803873:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803876:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80387a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80387d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803880:	89 c7                	mov    %eax,%edi
  803882:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  803889:	00 00 00 
  80388c:	ff d0                	callq  *%rax
  80388e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803895:	79 05                	jns    80389c <bind+0x31>
		return r;
  803897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389a:	eb 1b                	jmp    8038b7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80389c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80389f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a6:	48 89 ce             	mov    %rcx,%rsi
  8038a9:	89 c7                	mov    %eax,%edi
  8038ab:	48 b8 c6 3b 80 00 00 	movabs $0x803bc6,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
}
  8038b7:	c9                   	leaveq 
  8038b8:	c3                   	retq   

00000000008038b9 <shutdown>:

int
shutdown(int s, int how)
{
  8038b9:	55                   	push   %rbp
  8038ba:	48 89 e5             	mov    %rsp,%rbp
  8038bd:	48 83 ec 20          	sub    $0x20,%rsp
  8038c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038c4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ca:	89 c7                	mov    %eax,%edi
  8038cc:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  8038d3:	00 00 00 
  8038d6:	ff d0                	callq  *%rax
  8038d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038df:	79 05                	jns    8038e6 <shutdown+0x2d>
		return r;
  8038e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e4:	eb 16                	jmp    8038fc <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8038e6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ec:	89 d6                	mov    %edx,%esi
  8038ee:	89 c7                	mov    %eax,%edi
  8038f0:	48 b8 2a 3c 80 00 00 	movabs $0x803c2a,%rax
  8038f7:	00 00 00 
  8038fa:	ff d0                	callq  *%rax
}
  8038fc:	c9                   	leaveq 
  8038fd:	c3                   	retq   

00000000008038fe <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8038fe:	55                   	push   %rbp
  8038ff:	48 89 e5             	mov    %rsp,%rbp
  803902:	48 83 ec 10          	sub    $0x10,%rsp
  803906:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80390a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390e:	48 89 c7             	mov    %rax,%rdi
  803911:	48 b8 57 50 80 00 00 	movabs $0x805057,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	83 f8 01             	cmp    $0x1,%eax
  803920:	75 17                	jne    803939 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803926:	8b 40 0c             	mov    0xc(%rax),%eax
  803929:	89 c7                	mov    %eax,%edi
  80392b:	48 b8 6a 3c 80 00 00 	movabs $0x803c6a,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
  803937:	eb 05                	jmp    80393e <devsock_close+0x40>
	else
		return 0;
  803939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80393e:	c9                   	leaveq 
  80393f:	c3                   	retq   

0000000000803940 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803940:	55                   	push   %rbp
  803941:	48 89 e5             	mov    %rsp,%rbp
  803944:	48 83 ec 20          	sub    $0x20,%rsp
  803948:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80394b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80394f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803952:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803955:	89 c7                	mov    %eax,%edi
  803957:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  80395e:	00 00 00 
  803961:	ff d0                	callq  *%rax
  803963:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803966:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80396a:	79 05                	jns    803971 <connect+0x31>
		return r;
  80396c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396f:	eb 1b                	jmp    80398c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803971:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803974:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	48 89 ce             	mov    %rcx,%rsi
  80397e:	89 c7                	mov    %eax,%edi
  803980:	48 b8 97 3c 80 00 00 	movabs $0x803c97,%rax
  803987:	00 00 00 
  80398a:	ff d0                	callq  *%rax
}
  80398c:	c9                   	leaveq 
  80398d:	c3                   	retq   

000000000080398e <listen>:

int
listen(int s, int backlog)
{
  80398e:	55                   	push   %rbp
  80398f:	48 89 e5             	mov    %rsp,%rbp
  803992:	48 83 ec 20          	sub    $0x20,%rsp
  803996:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803999:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80399c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80399f:	89 c7                	mov    %eax,%edi
  8039a1:	48 b8 06 37 80 00 00 	movabs $0x803706,%rax
  8039a8:	00 00 00 
  8039ab:	ff d0                	callq  *%rax
  8039ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b4:	79 05                	jns    8039bb <listen+0x2d>
		return r;
  8039b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b9:	eb 16                	jmp    8039d1 <listen+0x43>
	return nsipc_listen(r, backlog);
  8039bb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c1:	89 d6                	mov    %edx,%esi
  8039c3:	89 c7                	mov    %eax,%edi
  8039c5:	48 b8 fb 3c 80 00 00 	movabs $0x803cfb,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
}
  8039d1:	c9                   	leaveq 
  8039d2:	c3                   	retq   

00000000008039d3 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039d3:	55                   	push   %rbp
  8039d4:	48 89 e5             	mov    %rsp,%rbp
  8039d7:	48 83 ec 20          	sub    $0x20,%rsp
  8039db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039eb:	89 c2                	mov    %eax,%edx
  8039ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f1:	8b 40 0c             	mov    0xc(%rax),%eax
  8039f4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039fd:	89 c7                	mov    %eax,%edi
  8039ff:	48 b8 3b 3d 80 00 00 	movabs $0x803d3b,%rax
  803a06:	00 00 00 
  803a09:	ff d0                	callq  *%rax
}
  803a0b:	c9                   	leaveq 
  803a0c:	c3                   	retq   

0000000000803a0d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803a0d:	55                   	push   %rbp
  803a0e:	48 89 e5             	mov    %rsp,%rbp
  803a11:	48 83 ec 20          	sub    $0x20,%rsp
  803a15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a25:	89 c2                	mov    %eax,%edx
  803a27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a2b:	8b 40 0c             	mov    0xc(%rax),%eax
  803a2e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a32:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a37:	89 c7                	mov    %eax,%edi
  803a39:	48 b8 07 3e 80 00 00 	movabs $0x803e07,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
}
  803a45:	c9                   	leaveq 
  803a46:	c3                   	retq   

0000000000803a47 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a47:	55                   	push   %rbp
  803a48:	48 89 e5             	mov    %rsp,%rbp
  803a4b:	48 83 ec 10          	sub    $0x10,%rsp
  803a4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5b:	48 be 27 5e 80 00 00 	movabs $0x805e27,%rsi
  803a62:	00 00 00 
  803a65:	48 89 c7             	mov    %rax,%rdi
  803a68:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
	return 0;
  803a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a79:	c9                   	leaveq 
  803a7a:	c3                   	retq   

0000000000803a7b <socket>:

int
socket(int domain, int type, int protocol)
{
  803a7b:	55                   	push   %rbp
  803a7c:	48 89 e5             	mov    %rsp,%rbp
  803a7f:	48 83 ec 20          	sub    $0x20,%rsp
  803a83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a86:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a89:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a8c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a8f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a95:	89 ce                	mov    %ecx,%esi
  803a97:	89 c7                	mov    %eax,%edi
  803a99:	48 b8 bf 3e 80 00 00 	movabs $0x803ebf,%rax
  803aa0:	00 00 00 
  803aa3:	ff d0                	callq  *%rax
  803aa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aac:	79 05                	jns    803ab3 <socket+0x38>
		return r;
  803aae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab1:	eb 11                	jmp    803ac4 <socket+0x49>
	return alloc_sockfd(r);
  803ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab6:	89 c7                	mov    %eax,%edi
  803ab8:	48 b8 5d 37 80 00 00 	movabs $0x80375d,%rax
  803abf:	00 00 00 
  803ac2:	ff d0                	callq  *%rax
}
  803ac4:	c9                   	leaveq 
  803ac5:	c3                   	retq   

0000000000803ac6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ac6:	55                   	push   %rbp
  803ac7:	48 89 e5             	mov    %rsp,%rbp
  803aca:	48 83 ec 10          	sub    $0x10,%rsp
  803ace:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803ad1:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803ad8:	00 00 00 
  803adb:	8b 00                	mov    (%rax),%eax
  803add:	85 c0                	test   %eax,%eax
  803adf:	75 1d                	jne    803afe <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803ae1:	bf 02 00 00 00       	mov    $0x2,%edi
  803ae6:	48 b8 e5 4f 80 00 00 	movabs $0x804fe5,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
  803af2:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  803af9:	00 00 00 
  803afc:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803afe:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803b05:	00 00 00 
  803b08:	8b 00                	mov    (%rax),%eax
  803b0a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803b0d:	b9 07 00 00 00       	mov    $0x7,%ecx
  803b12:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  803b19:	00 00 00 
  803b1c:	89 c7                	mov    %eax,%edi
  803b1e:	48 b8 d9 4d 80 00 00 	movabs $0x804dd9,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  803b2f:	be 00 00 00 00       	mov    $0x0,%esi
  803b34:	bf 00 00 00 00       	mov    $0x0,%edi
  803b39:	48 b8 18 4d 80 00 00 	movabs $0x804d18,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
}
  803b45:	c9                   	leaveq 
  803b46:	c3                   	retq   

0000000000803b47 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b47:	55                   	push   %rbp
  803b48:	48 89 e5             	mov    %rsp,%rbp
  803b4b:	48 83 ec 30          	sub    $0x30,%rsp
  803b4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b5a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803b61:	00 00 00 
  803b64:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b67:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803b69:	bf 01 00 00 00       	mov    $0x1,%edi
  803b6e:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
  803b7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b81:	78 3e                	js     803bc1 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b83:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803b8a:	00 00 00 
  803b8d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b95:	8b 40 10             	mov    0x10(%rax),%eax
  803b98:	89 c2                	mov    %eax,%edx
  803b9a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba2:	48 89 ce             	mov    %rcx,%rsi
  803ba5:	48 89 c7             	mov    %rax,%rdi
  803ba8:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  803baf:	00 00 00 
  803bb2:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb8:	8b 50 10             	mov    0x10(%rax),%edx
  803bbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bbf:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bc4:	c9                   	leaveq 
  803bc5:	c3                   	retq   

0000000000803bc6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bc6:	55                   	push   %rbp
  803bc7:	48 89 e5             	mov    %rsp,%rbp
  803bca:	48 83 ec 10          	sub    $0x10,%rsp
  803bce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bd1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bd5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803bd8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803bdf:	00 00 00 
  803be2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803be5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803be7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bee:	48 89 c6             	mov    %rax,%rsi
  803bf1:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803bf8:	00 00 00 
  803bfb:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  803c02:	00 00 00 
  803c05:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803c07:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803c0e:	00 00 00 
  803c11:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c14:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c17:	bf 02 00 00 00       	mov    $0x2,%edi
  803c1c:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
}
  803c28:	c9                   	leaveq 
  803c29:	c3                   	retq   

0000000000803c2a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c2a:	55                   	push   %rbp
  803c2b:	48 89 e5             	mov    %rsp,%rbp
  803c2e:	48 83 ec 10          	sub    $0x10,%rsp
  803c32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c35:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c38:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803c3f:	00 00 00 
  803c42:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c45:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c47:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803c4e:	00 00 00 
  803c51:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c54:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c57:	bf 03 00 00 00       	mov    $0x3,%edi
  803c5c:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803c63:	00 00 00 
  803c66:	ff d0                	callq  *%rax
}
  803c68:	c9                   	leaveq 
  803c69:	c3                   	retq   

0000000000803c6a <nsipc_close>:

int
nsipc_close(int s)
{
  803c6a:	55                   	push   %rbp
  803c6b:	48 89 e5             	mov    %rsp,%rbp
  803c6e:	48 83 ec 10          	sub    $0x10,%rsp
  803c72:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c75:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803c7c:	00 00 00 
  803c7f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c82:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c84:	bf 04 00 00 00       	mov    $0x4,%edi
  803c89:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	callq  *%rax
}
  803c95:	c9                   	leaveq 
  803c96:	c3                   	retq   

0000000000803c97 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c97:	55                   	push   %rbp
  803c98:	48 89 e5             	mov    %rsp,%rbp
  803c9b:	48 83 ec 10          	sub    $0x10,%rsp
  803c9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ca2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ca6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ca9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803cb0:	00 00 00 
  803cb3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cb6:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803cb8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbf:	48 89 c6             	mov    %rax,%rsi
  803cc2:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803cc9:	00 00 00 
  803ccc:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  803cd3:	00 00 00 
  803cd6:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803cd8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803cdf:	00 00 00 
  803ce2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ce5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803ce8:	bf 05 00 00 00       	mov    $0x5,%edi
  803ced:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax
}
  803cf9:	c9                   	leaveq 
  803cfa:	c3                   	retq   

0000000000803cfb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803cfb:	55                   	push   %rbp
  803cfc:	48 89 e5             	mov    %rsp,%rbp
  803cff:	48 83 ec 10          	sub    $0x10,%rsp
  803d03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d06:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803d09:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d10:	00 00 00 
  803d13:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d16:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d18:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d1f:	00 00 00 
  803d22:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d25:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d28:	bf 06 00 00 00       	mov    $0x6,%edi
  803d2d:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803d34:	00 00 00 
  803d37:	ff d0                	callq  *%rax
}
  803d39:	c9                   	leaveq 
  803d3a:	c3                   	retq   

0000000000803d3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d3b:	55                   	push   %rbp
  803d3c:	48 89 e5             	mov    %rsp,%rbp
  803d3f:	48 83 ec 30          	sub    $0x30,%rsp
  803d43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d4a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d4d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d50:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d57:	00 00 00 
  803d5a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d5d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d5f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d66:	00 00 00 
  803d69:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d6c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803d6f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d76:	00 00 00 
  803d79:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d7c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d7f:	bf 07 00 00 00       	mov    $0x7,%edi
  803d84:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
  803d90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d97:	78 69                	js     803e02 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d99:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803da0:	7f 08                	jg     803daa <nsipc_recv+0x6f>
  803da2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da5:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803da8:	7e 35                	jle    803ddf <nsipc_recv+0xa4>
  803daa:	48 b9 2e 5e 80 00 00 	movabs $0x805e2e,%rcx
  803db1:	00 00 00 
  803db4:	48 ba 43 5e 80 00 00 	movabs $0x805e43,%rdx
  803dbb:	00 00 00 
  803dbe:	be 62 00 00 00       	mov    $0x62,%esi
  803dc3:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803dca:	00 00 00 
  803dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd2:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  803dd9:	00 00 00 
  803ddc:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de2:	48 63 d0             	movslq %eax,%rdx
  803de5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de9:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  803df0:	00 00 00 
  803df3:	48 89 c7             	mov    %rax,%rdi
  803df6:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  803dfd:	00 00 00 
  803e00:	ff d0                	callq  *%rax
	}

	return r;
  803e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e05:	c9                   	leaveq 
  803e06:	c3                   	retq   

0000000000803e07 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803e07:	55                   	push   %rbp
  803e08:	48 89 e5             	mov    %rsp,%rbp
  803e0b:	48 83 ec 20          	sub    $0x20,%rsp
  803e0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e16:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e19:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e1c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803e23:	00 00 00 
  803e26:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e29:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e2b:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e32:	7e 35                	jle    803e69 <nsipc_send+0x62>
  803e34:	48 b9 64 5e 80 00 00 	movabs $0x805e64,%rcx
  803e3b:	00 00 00 
  803e3e:	48 ba 43 5e 80 00 00 	movabs $0x805e43,%rdx
  803e45:	00 00 00 
  803e48:	be 6d 00 00 00       	mov    $0x6d,%esi
  803e4d:	48 bf 58 5e 80 00 00 	movabs $0x805e58,%rdi
  803e54:	00 00 00 
  803e57:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5c:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  803e63:	00 00 00 
  803e66:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e6c:	48 63 d0             	movslq %eax,%rdx
  803e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e73:	48 89 c6             	mov    %rax,%rsi
  803e76:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  803e7d:	00 00 00 
  803e80:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  803e87:	00 00 00 
  803e8a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e8c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803e93:	00 00 00 
  803e96:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e99:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e9c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803ea3:	00 00 00 
  803ea6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ea9:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803eac:	bf 08 00 00 00       	mov    $0x8,%edi
  803eb1:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803eb8:	00 00 00 
  803ebb:	ff d0                	callq  *%rax
}
  803ebd:	c9                   	leaveq 
  803ebe:	c3                   	retq   

0000000000803ebf <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ebf:	55                   	push   %rbp
  803ec0:	48 89 e5             	mov    %rsp,%rbp
  803ec3:	48 83 ec 10          	sub    $0x10,%rsp
  803ec7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803eca:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ecd:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ed0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803ed7:	00 00 00 
  803eda:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803edd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803edf:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803ee6:	00 00 00 
  803ee9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803eec:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803eef:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803ef6:	00 00 00 
  803ef9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803efc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803eff:	bf 09 00 00 00       	mov    $0x9,%edi
  803f04:	48 b8 c6 3a 80 00 00 	movabs $0x803ac6,%rax
  803f0b:	00 00 00 
  803f0e:	ff d0                	callq  *%rax
}
  803f10:	c9                   	leaveq 
  803f11:	c3                   	retq   

0000000000803f12 <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  803f12:	55                   	push   %rbp
  803f13:	48 89 e5             	mov    %rsp,%rbp
  803f16:	48 83 ec 20          	sub    $0x20,%rsp
  803f1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  803f22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f2a:	48 01 d0             	add    %rdx,%rax
  803f2d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803f39:	eb 64                	jmp    803f9f <isfree+0x8d>
		if (va >= (uintptr_t) mend
  803f3b:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  803f42:	00 00 00 
  803f45:	48 8b 00             	mov    (%rax),%rax
  803f48:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803f4c:	76 42                	jbe    803f90 <isfree+0x7e>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803f4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f52:	48 c1 e8 15          	shr    $0x15,%rax
  803f56:	48 89 c2             	mov    %rax,%rdx
  803f59:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f60:	01 00 00 
  803f63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f67:	83 e0 01             	and    $0x1,%eax
  803f6a:	48 85 c0             	test   %rax,%rax
  803f6d:	74 28                	je     803f97 <isfree+0x85>
  803f6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f73:	48 c1 e8 0c          	shr    $0xc,%rax
  803f77:	48 89 c2             	mov    %rax,%rdx
  803f7a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f81:	01 00 00 
  803f84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f88:	83 e0 01             	and    $0x1,%eax
  803f8b:	48 85 c0             	test   %rax,%rax
  803f8e:	74 07                	je     803f97 <isfree+0x85>
			return 0;
  803f90:	b8 00 00 00 00       	mov    $0x0,%eax
  803f95:	eb 17                	jmp    803fae <isfree+0x9c>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803f97:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803f9e:	00 
  803f9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803fa7:	72 92                	jb     803f3b <isfree+0x29>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  803fa9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803fae:	c9                   	leaveq 
  803faf:	c3                   	retq   

0000000000803fb0 <malloc>:

void*
malloc(size_t n)
{
  803fb0:	55                   	push   %rbp
  803fb1:	48 89 e5             	mov    %rsp,%rbp
  803fb4:	48 83 ec 60          	sub    $0x60,%rsp
  803fb8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803fbc:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803fc3:	00 00 00 
  803fc6:	48 8b 00             	mov    (%rax),%rax
  803fc9:	48 85 c0             	test   %rax,%rax
  803fcc:	75 1a                	jne    803fe8 <malloc+0x38>
		mptr = mbegin;
  803fce:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  803fd5:	00 00 00 
  803fd8:	48 8b 10             	mov    (%rax),%rdx
  803fdb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803fe2:	00 00 00 
  803fe5:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  803fe8:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  803fef:	00 
  803ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803ff8:	48 01 d0             	add    %rdx,%rax
  803ffb:	48 83 e8 01          	sub    $0x1,%rax
  803fff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804007:	ba 00 00 00 00       	mov    $0x0,%edx
  80400c:	48 f7 75 f0          	divq   -0x10(%rbp)
  804010:	48 89 d0             	mov    %rdx,%rax
  804013:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804017:	48 29 c2             	sub    %rax,%rdx
  80401a:	48 89 d0             	mov    %rdx,%rax
  80401d:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	if (n >= MAXMALLOC)
  804021:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  804028:	00 
  804029:	76 0a                	jbe    804035 <malloc+0x85>
		return 0;
  80402b:	b8 00 00 00 00       	mov    $0x0,%eax
  804030:	e9 f7 02 00 00       	jmpq   80432c <malloc+0x37c>

	if ((uintptr_t) mptr % PGSIZE){
  804035:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80403c:	00 00 00 
  80403f:	48 8b 00             	mov    (%rax),%rax
  804042:	25 ff 0f 00 00       	and    $0xfff,%eax
  804047:	48 85 c0             	test   %rax,%rax
  80404a:	0f 84 15 01 00 00    	je     804165 <malloc+0x1b5>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  804050:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  804057:	00 
  804058:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80405f:	00 00 00 
  804062:	48 8b 00             	mov    (%rax),%rax
  804065:	48 89 c2             	mov    %rax,%rdx
  804068:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80406c:	48 01 d0             	add    %rdx,%rax
  80406f:	48 83 e8 01          	sub    $0x1,%rax
  804073:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804077:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80407b:	ba 00 00 00 00       	mov    $0x0,%edx
  804080:	48 f7 75 e0          	divq   -0x20(%rbp)
  804084:	48 89 d0             	mov    %rdx,%rax
  804087:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80408b:	48 29 c2             	sub    %rax,%rdx
  80408e:	48 89 d0             	mov    %rdx,%rax
  804091:	48 83 e8 04          	sub    $0x4,%rax
  804095:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  804099:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040a0:	00 00 00 
  8040a3:	48 8b 00             	mov    (%rax),%rax
  8040a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8040aa:	48 89 c1             	mov    %rax,%rcx
  8040ad:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040b4:	00 00 00 
  8040b7:	48 8b 00             	mov    (%rax),%rax
  8040ba:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8040be:	48 83 c2 03          	add    $0x3,%rdx
  8040c2:	48 01 d0             	add    %rdx,%rax
  8040c5:	48 c1 e8 0c          	shr    $0xc,%rax
  8040c9:	48 39 c1             	cmp    %rax,%rcx
  8040cc:	75 4a                	jne    804118 <malloc+0x168>
			(*ref)++;
  8040ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040d2:	8b 00                	mov    (%rax),%eax
  8040d4:	8d 50 01             	lea    0x1(%rax),%edx
  8040d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040db:	89 10                	mov    %edx,(%rax)
			v = mptr;
  8040dd:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040e4:	00 00 00 
  8040e7:	48 8b 00             	mov    (%rax),%rax
  8040ea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  8040ee:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040f5:	00 00 00 
  8040f8:	48 8b 10             	mov    (%rax),%rdx
  8040fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8040ff:	48 01 c2             	add    %rax,%rdx
  804102:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804109:	00 00 00 
  80410c:	48 89 10             	mov    %rdx,(%rax)
			return v;
  80410f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804113:	e9 14 02 00 00       	jmpq   80432c <malloc+0x37c>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  804118:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80411f:	00 00 00 
  804122:	48 8b 00             	mov    (%rax),%rax
  804125:	48 89 c7             	mov    %rax,%rdi
  804128:	48 b8 2e 43 80 00 00 	movabs $0x80432e,%rax
  80412f:	00 00 00 
  804132:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  804134:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80413b:	00 00 00 
  80413e:	48 8b 00             	mov    (%rax),%rax
  804141:	48 05 00 10 00 00    	add    $0x1000,%rax
  804147:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80414b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80414f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804155:	48 89 c2             	mov    %rax,%rdx
  804158:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80415f:	00 00 00 
  804162:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  804165:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	while (1) {
		if (isfree(mptr, n + 4))
  80416c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804170:	48 8d 50 04          	lea    0x4(%rax),%rdx
  804174:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80417b:	00 00 00 
  80417e:	48 8b 00             	mov    (%rax),%rax
  804181:	48 89 d6             	mov    %rdx,%rsi
  804184:	48 89 c7             	mov    %rax,%rdi
  804187:	48 b8 12 3f 80 00 00 	movabs $0x803f12,%rax
  80418e:	00 00 00 
  804191:	ff d0                	callq  *%rax
  804193:	85 c0                	test   %eax,%eax
  804195:	74 0d                	je     8041a4 <malloc+0x1f4>
			break;
  804197:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  804198:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80419f:	e9 14 01 00 00       	jmpq   8042b8 <malloc+0x308>
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
  8041a4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041ab:	00 00 00 
  8041ae:	48 8b 00             	mov    (%rax),%rax
  8041b1:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  8041b8:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041bf:	00 00 00 
  8041c2:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  8041c5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041cc:	00 00 00 
  8041cf:	48 8b 10             	mov    (%rax),%rdx
  8041d2:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  8041d9:	00 00 00 
  8041dc:	48 8b 00             	mov    (%rax),%rax
  8041df:	48 39 c2             	cmp    %rax,%rdx
  8041e2:	75 2e                	jne    804212 <malloc+0x262>
			mptr = mbegin;
  8041e4:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  8041eb:	00 00 00 
  8041ee:	48 8b 10             	mov    (%rax),%rdx
  8041f1:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041f8:	00 00 00 
  8041fb:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  8041fe:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  804202:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  804206:	75 0a                	jne    804212 <malloc+0x262>
				return 0;	/* out of address space */
  804208:	b8 00 00 00 00       	mov    $0x0,%eax
  80420d:	e9 1a 01 00 00       	jmpq   80432c <malloc+0x37c>
		}
	}
  804212:	e9 55 ff ff ff       	jmpq   80416c <malloc+0x1bc>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  804217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421a:	05 00 10 00 00       	add    $0x1000,%eax
  80421f:	48 98                	cltq   
  804221:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804225:	48 83 c2 04          	add    $0x4,%rdx
  804229:	48 39 d0             	cmp    %rdx,%rax
  80422c:	73 07                	jae    804235 <malloc+0x285>
  80422e:	b8 00 04 00 00       	mov    $0x400,%eax
  804233:	eb 05                	jmp    80423a <malloc+0x28a>
  804235:	b8 00 00 00 00       	mov    $0x0,%eax
  80423a:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80423d:	8b 45 bc             	mov    -0x44(%rbp),%eax
  804240:	83 c8 07             	or     $0x7,%eax
  804243:	89 c2                	mov    %eax,%edx
  804245:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80424c:	00 00 00 
  80424f:	48 8b 08             	mov    (%rax),%rcx
  804252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804255:	48 98                	cltq   
  804257:	48 01 c8             	add    %rcx,%rax
  80425a:	48 89 c6             	mov    %rax,%rsi
  80425d:	bf 00 00 00 00       	mov    $0x0,%edi
  804262:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  804269:	00 00 00 
  80426c:	ff d0                	callq  *%rax
  80426e:	85 c0                	test   %eax,%eax
  804270:	79 3f                	jns    8042b1 <malloc+0x301>
			for (; i >= 0; i -= PGSIZE)
  804272:	eb 30                	jmp    8042a4 <malloc+0x2f4>
				sys_page_unmap(0, mptr + i);
  804274:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80427b:	00 00 00 
  80427e:	48 8b 10             	mov    (%rax),%rdx
  804281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804284:	48 98                	cltq   
  804286:	48 01 d0             	add    %rdx,%rax
  804289:	48 89 c6             	mov    %rax,%rsi
  80428c:	bf 00 00 00 00       	mov    $0x0,%edi
  804291:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  804298:	00 00 00 
  80429b:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  80429d:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  8042a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a8:	79 ca                	jns    804274 <malloc+0x2c4>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  8042aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8042af:	eb 7b                	jmp    80432c <malloc+0x37c>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  8042b1:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8042b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042bb:	48 98                	cltq   
  8042bd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8042c1:	48 83 c2 04          	add    $0x4,%rdx
  8042c5:	48 39 d0             	cmp    %rdx,%rax
  8042c8:	0f 82 49 ff ff ff    	jb     804217 <malloc+0x267>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  8042ce:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8042d5:	00 00 00 
  8042d8:	48 8b 00             	mov    (%rax),%rax
  8042db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042de:	48 63 d2             	movslq %edx,%rdx
  8042e1:	48 83 ea 04          	sub    $0x4,%rdx
  8042e5:	48 01 d0             	add    %rdx,%rax
  8042e8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  8042ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042f0:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  8042f6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8042fd:	00 00 00 
  804300:	48 8b 00             	mov    (%rax),%rax
  804303:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  804307:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80430e:	00 00 00 
  804311:	48 8b 10             	mov    (%rax),%rdx
  804314:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804318:	48 01 c2             	add    %rax,%rdx
  80431b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804322:	00 00 00 
  804325:	48 89 10             	mov    %rdx,(%rax)
	return v;
  804328:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  80432c:	c9                   	leaveq 
  80432d:	c3                   	retq   

000000000080432e <free>:

void
free(void *v)
{
  80432e:	55                   	push   %rbp
  80432f:	48 89 e5             	mov    %rsp,%rbp
  804332:	48 83 ec 30          	sub    $0x30,%rsp
  804336:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80433a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80433f:	75 05                	jne    804346 <free+0x18>
		return;
  804341:	e9 54 01 00 00       	jmpq   80449a <free+0x16c>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  804346:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  80434d:	00 00 00 
  804350:	48 8b 00             	mov    (%rax),%rax
  804353:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804357:	77 13                	ja     80436c <free+0x3e>
  804359:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  804360:	00 00 00 
  804363:	48 8b 00             	mov    (%rax),%rax
  804366:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80436a:	72 35                	jb     8043a1 <free+0x73>
  80436c:	48 b9 70 5e 80 00 00 	movabs $0x805e70,%rcx
  804373:	00 00 00 
  804376:	48 ba 9e 5e 80 00 00 	movabs $0x805e9e,%rdx
  80437d:	00 00 00 
  804380:	be 7b 00 00 00       	mov    $0x7b,%esi
  804385:	48 bf b3 5e 80 00 00 	movabs $0x805eb3,%rdi
  80438c:	00 00 00 
  80438f:	b8 00 00 00 00       	mov    $0x0,%eax
  804394:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  80439b:	00 00 00 
  80439e:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  8043a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8043a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ad:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8043b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8043b7:	eb 7b                	jmp    804434 <free+0x106>
		sys_page_unmap(0, c);
  8043b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043bd:	48 89 c6             	mov    %rax,%rsi
  8043c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8043c5:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  8043cc:	00 00 00 
  8043cf:	ff d0                	callq  *%rax
		c += PGSIZE;
  8043d1:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8043d8:	00 
		assert(mbegin <= c && c < mend);
  8043d9:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  8043e0:	00 00 00 
  8043e3:	48 8b 00             	mov    (%rax),%rax
  8043e6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8043ea:	77 13                	ja     8043ff <free+0xd1>
  8043ec:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  8043f3:	00 00 00 
  8043f6:	48 8b 00             	mov    (%rax),%rax
  8043f9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8043fd:	72 35                	jb     804434 <free+0x106>
  8043ff:	48 b9 c0 5e 80 00 00 	movabs $0x805ec0,%rcx
  804406:	00 00 00 
  804409:	48 ba 9e 5e 80 00 00 	movabs $0x805e9e,%rdx
  804410:	00 00 00 
  804413:	be 82 00 00 00       	mov    $0x82,%esi
  804418:	48 bf b3 5e 80 00 00 	movabs $0x805eb3,%rdi
  80441f:	00 00 00 
  804422:	b8 00 00 00 00       	mov    $0x0,%eax
  804427:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  80442e:	00 00 00 
  804431:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  804434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804438:	48 c1 e8 0c          	shr    $0xc,%rax
  80443c:	48 89 c2             	mov    %rax,%rdx
  80443f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804446:	01 00 00 
  804449:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80444d:	25 00 04 00 00       	and    $0x400,%eax
  804452:	48 85 c0             	test   %rax,%rax
  804455:	0f 85 5e ff ff ff    	jne    8043b9 <free+0x8b>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  80445b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80445f:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  804465:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  804469:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80446d:	8b 00                	mov    (%rax),%eax
  80446f:	8d 50 ff             	lea    -0x1(%rax),%edx
  804472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804476:	89 10                	mov    %edx,(%rax)
  804478:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80447c:	8b 00                	mov    (%rax),%eax
  80447e:	85 c0                	test   %eax,%eax
  804480:	75 18                	jne    80449a <free+0x16c>
		sys_page_unmap(0, c);
  804482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804486:	48 89 c6             	mov    %rax,%rsi
  804489:	bf 00 00 00 00       	mov    $0x0,%edi
  80448e:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  804495:	00 00 00 
  804498:	ff d0                	callq  *%rax
}
  80449a:	c9                   	leaveq 
  80449b:	c3                   	retq   

000000000080449c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80449c:	55                   	push   %rbp
  80449d:	48 89 e5             	mov    %rsp,%rbp
  8044a0:	53                   	push   %rbx
  8044a1:	48 83 ec 38          	sub    $0x38,%rsp
  8044a5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8044a9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8044ad:	48 89 c7             	mov    %rax,%rdi
  8044b0:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  8044b7:	00 00 00 
  8044ba:	ff d0                	callq  *%rax
  8044bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044c3:	0f 88 bf 01 00 00    	js     804688 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8044c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8044d2:	48 89 c6             	mov    %rax,%rsi
  8044d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8044da:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  8044e1:	00 00 00 
  8044e4:	ff d0                	callq  *%rax
  8044e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044ed:	0f 88 95 01 00 00    	js     804688 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8044f3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8044f7:	48 89 c7             	mov    %rax,%rdi
  8044fa:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  804501:	00 00 00 
  804504:	ff d0                	callq  *%rax
  804506:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804509:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80450d:	0f 88 5d 01 00 00    	js     804670 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804513:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804517:	ba 07 04 00 00       	mov    $0x407,%edx
  80451c:	48 89 c6             	mov    %rax,%rsi
  80451f:	bf 00 00 00 00       	mov    $0x0,%edi
  804524:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  80452b:	00 00 00 
  80452e:	ff d0                	callq  *%rax
  804530:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804533:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804537:	0f 88 33 01 00 00    	js     804670 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80453d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804541:	48 89 c7             	mov    %rax,%rdi
  804544:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  80454b:	00 00 00 
  80454e:	ff d0                	callq  *%rax
  804550:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804554:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804558:	ba 07 04 00 00       	mov    $0x407,%edx
  80455d:	48 89 c6             	mov    %rax,%rsi
  804560:	bf 00 00 00 00       	mov    $0x0,%edi
  804565:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  80456c:	00 00 00 
  80456f:	ff d0                	callq  *%rax
  804571:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804574:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804578:	79 05                	jns    80457f <pipe+0xe3>
		goto err2;
  80457a:	e9 d9 00 00 00       	jmpq   804658 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80457f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804583:	48 89 c7             	mov    %rax,%rdi
  804586:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  80458d:	00 00 00 
  804590:	ff d0                	callq  *%rax
  804592:	48 89 c2             	mov    %rax,%rdx
  804595:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804599:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80459f:	48 89 d1             	mov    %rdx,%rcx
  8045a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8045a7:	48 89 c6             	mov    %rax,%rsi
  8045aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8045af:	48 b8 4b 23 80 00 00 	movabs $0x80234b,%rax
  8045b6:	00 00 00 
  8045b9:	ff d0                	callq  *%rax
  8045bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045c2:	79 1b                	jns    8045df <pipe+0x143>
		goto err3;
  8045c4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8045c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045c9:	48 89 c6             	mov    %rax,%rsi
  8045cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8045d1:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  8045d8:	00 00 00 
  8045db:	ff d0                	callq  *%rax
  8045dd:	eb 79                	jmp    804658 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8045df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045e3:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  8045ea:	00 00 00 
  8045ed:	8b 12                	mov    (%rdx),%edx
  8045ef:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8045f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8045fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804600:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  804607:	00 00 00 
  80460a:	8b 12                	mov    (%rdx),%edx
  80460c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80460e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804612:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461d:	48 89 c7             	mov    %rax,%rdi
  804620:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  804627:	00 00 00 
  80462a:	ff d0                	callq  *%rax
  80462c:	89 c2                	mov    %eax,%edx
  80462e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804632:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804634:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804638:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80463c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804640:	48 89 c7             	mov    %rax,%rdi
  804643:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  80464a:	00 00 00 
  80464d:	ff d0                	callq  *%rax
  80464f:	89 03                	mov    %eax,(%rbx)
	return 0;
  804651:	b8 00 00 00 00       	mov    $0x0,%eax
  804656:	eb 33                	jmp    80468b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804658:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80465c:	48 89 c6             	mov    %rax,%rsi
  80465f:	bf 00 00 00 00       	mov    $0x0,%edi
  804664:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  80466b:	00 00 00 
  80466e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804674:	48 89 c6             	mov    %rax,%rsi
  804677:	bf 00 00 00 00       	mov    $0x0,%edi
  80467c:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  804683:	00 00 00 
  804686:	ff d0                	callq  *%rax
err:
	return r;
  804688:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80468b:	48 83 c4 38          	add    $0x38,%rsp
  80468f:	5b                   	pop    %rbx
  804690:	5d                   	pop    %rbp
  804691:	c3                   	retq   

0000000000804692 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804692:	55                   	push   %rbp
  804693:	48 89 e5             	mov    %rsp,%rbp
  804696:	53                   	push   %rbx
  804697:	48 83 ec 28          	sub    $0x28,%rsp
  80469b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80469f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8046a3:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8046aa:	00 00 00 
  8046ad:	48 8b 00             	mov    (%rax),%rax
  8046b0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8046b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8046b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046bd:	48 89 c7             	mov    %rax,%rdi
  8046c0:	48 b8 57 50 80 00 00 	movabs $0x805057,%rax
  8046c7:	00 00 00 
  8046ca:	ff d0                	callq  *%rax
  8046cc:	89 c3                	mov    %eax,%ebx
  8046ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046d2:	48 89 c7             	mov    %rax,%rdi
  8046d5:	48 b8 57 50 80 00 00 	movabs $0x805057,%rax
  8046dc:	00 00 00 
  8046df:	ff d0                	callq  *%rax
  8046e1:	39 c3                	cmp    %eax,%ebx
  8046e3:	0f 94 c0             	sete   %al
  8046e6:	0f b6 c0             	movzbl %al,%eax
  8046e9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8046ec:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8046f3:	00 00 00 
  8046f6:	48 8b 00             	mov    (%rax),%rax
  8046f9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8046ff:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804702:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804705:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804708:	75 05                	jne    80470f <_pipeisclosed+0x7d>
			return ret;
  80470a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80470d:	eb 4f                	jmp    80475e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80470f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804712:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804715:	74 42                	je     804759 <_pipeisclosed+0xc7>
  804717:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80471b:	75 3c                	jne    804759 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80471d:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804724:	00 00 00 
  804727:	48 8b 00             	mov    (%rax),%rax
  80472a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804730:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804733:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804736:	89 c6                	mov    %eax,%esi
  804738:	48 bf dd 5e 80 00 00 	movabs $0x805edd,%rdi
  80473f:	00 00 00 
  804742:	b8 00 00 00 00       	mov    $0x0,%eax
  804747:	49 b8 17 0e 80 00 00 	movabs $0x800e17,%r8
  80474e:	00 00 00 
  804751:	41 ff d0             	callq  *%r8
	}
  804754:	e9 4a ff ff ff       	jmpq   8046a3 <_pipeisclosed+0x11>
  804759:	e9 45 ff ff ff       	jmpq   8046a3 <_pipeisclosed+0x11>

}
  80475e:	48 83 c4 28          	add    $0x28,%rsp
  804762:	5b                   	pop    %rbx
  804763:	5d                   	pop    %rbp
  804764:	c3                   	retq   

0000000000804765 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804765:	55                   	push   %rbp
  804766:	48 89 e5             	mov    %rsp,%rbp
  804769:	48 83 ec 30          	sub    $0x30,%rsp
  80476d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804770:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804774:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804777:	48 89 d6             	mov    %rdx,%rsi
  80477a:	89 c7                	mov    %eax,%edi
  80477c:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  804783:	00 00 00 
  804786:	ff d0                	callq  *%rax
  804788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80478b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80478f:	79 05                	jns    804796 <pipeisclosed+0x31>
		return r;
  804791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804794:	eb 31                	jmp    8047c7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80479a:	48 89 c7             	mov    %rax,%rdi
  80479d:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  8047a4:	00 00 00 
  8047a7:	ff d0                	callq  *%rax
  8047a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8047ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047b5:	48 89 d6             	mov    %rdx,%rsi
  8047b8:	48 89 c7             	mov    %rax,%rdi
  8047bb:	48 b8 92 46 80 00 00 	movabs $0x804692,%rax
  8047c2:	00 00 00 
  8047c5:	ff d0                	callq  *%rax
}
  8047c7:	c9                   	leaveq 
  8047c8:	c3                   	retq   

00000000008047c9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8047c9:	55                   	push   %rbp
  8047ca:	48 89 e5             	mov    %rsp,%rbp
  8047cd:	48 83 ec 40          	sub    $0x40,%rsp
  8047d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8047d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8047dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047e1:	48 89 c7             	mov    %rax,%rdi
  8047e4:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  8047eb:	00 00 00 
  8047ee:	ff d0                	callq  *%rax
  8047f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8047f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8047fc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804803:	00 
  804804:	e9 92 00 00 00       	jmpq   80489b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804809:	eb 41                	jmp    80484c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80480b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804810:	74 09                	je     80481b <devpipe_read+0x52>
				return i;
  804812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804816:	e9 92 00 00 00       	jmpq   8048ad <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80481b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80481f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804823:	48 89 d6             	mov    %rdx,%rsi
  804826:	48 89 c7             	mov    %rax,%rdi
  804829:	48 b8 92 46 80 00 00 	movabs $0x804692,%rax
  804830:	00 00 00 
  804833:	ff d0                	callq  *%rax
  804835:	85 c0                	test   %eax,%eax
  804837:	74 07                	je     804840 <devpipe_read+0x77>
				return 0;
  804839:	b8 00 00 00 00       	mov    $0x0,%eax
  80483e:	eb 6d                	jmp    8048ad <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804840:	48 b8 bd 22 80 00 00 	movabs $0x8022bd,%rax
  804847:	00 00 00 
  80484a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80484c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804850:	8b 10                	mov    (%rax),%edx
  804852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804856:	8b 40 04             	mov    0x4(%rax),%eax
  804859:	39 c2                	cmp    %eax,%edx
  80485b:	74 ae                	je     80480b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80485d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804861:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804865:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804869:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80486d:	8b 00                	mov    (%rax),%eax
  80486f:	99                   	cltd   
  804870:	c1 ea 1b             	shr    $0x1b,%edx
  804873:	01 d0                	add    %edx,%eax
  804875:	83 e0 1f             	and    $0x1f,%eax
  804878:	29 d0                	sub    %edx,%eax
  80487a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80487e:	48 98                	cltq   
  804880:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804885:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80488b:	8b 00                	mov    (%rax),%eax
  80488d:	8d 50 01             	lea    0x1(%rax),%edx
  804890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804894:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804896:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80489b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80489f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8048a3:	0f 82 60 ff ff ff    	jb     804809 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8048a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8048ad:	c9                   	leaveq 
  8048ae:	c3                   	retq   

00000000008048af <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8048af:	55                   	push   %rbp
  8048b0:	48 89 e5             	mov    %rsp,%rbp
  8048b3:	48 83 ec 40          	sub    $0x40,%rsp
  8048b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8048bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8048bf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8048c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048c7:	48 89 c7             	mov    %rax,%rdi
  8048ca:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  8048d1:	00 00 00 
  8048d4:	ff d0                	callq  *%rax
  8048d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8048da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8048e2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8048e9:	00 
  8048ea:	e9 8e 00 00 00       	jmpq   80497d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8048ef:	eb 31                	jmp    804922 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8048f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048f9:	48 89 d6             	mov    %rdx,%rsi
  8048fc:	48 89 c7             	mov    %rax,%rdi
  8048ff:	48 b8 92 46 80 00 00 	movabs $0x804692,%rax
  804906:	00 00 00 
  804909:	ff d0                	callq  *%rax
  80490b:	85 c0                	test   %eax,%eax
  80490d:	74 07                	je     804916 <devpipe_write+0x67>
				return 0;
  80490f:	b8 00 00 00 00       	mov    $0x0,%eax
  804914:	eb 79                	jmp    80498f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804916:	48 b8 bd 22 80 00 00 	movabs $0x8022bd,%rax
  80491d:	00 00 00 
  804920:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804922:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804926:	8b 40 04             	mov    0x4(%rax),%eax
  804929:	48 63 d0             	movslq %eax,%rdx
  80492c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804930:	8b 00                	mov    (%rax),%eax
  804932:	48 98                	cltq   
  804934:	48 83 c0 20          	add    $0x20,%rax
  804938:	48 39 c2             	cmp    %rax,%rdx
  80493b:	73 b4                	jae    8048f1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80493d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804941:	8b 40 04             	mov    0x4(%rax),%eax
  804944:	99                   	cltd   
  804945:	c1 ea 1b             	shr    $0x1b,%edx
  804948:	01 d0                	add    %edx,%eax
  80494a:	83 e0 1f             	and    $0x1f,%eax
  80494d:	29 d0                	sub    %edx,%eax
  80494f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804953:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804957:	48 01 ca             	add    %rcx,%rdx
  80495a:	0f b6 0a             	movzbl (%rdx),%ecx
  80495d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804961:	48 98                	cltq   
  804963:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80496b:	8b 40 04             	mov    0x4(%rax),%eax
  80496e:	8d 50 01             	lea    0x1(%rax),%edx
  804971:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804975:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804978:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80497d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804981:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804985:	0f 82 64 ff ff ff    	jb     8048ef <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80498b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80498f:	c9                   	leaveq 
  804990:	c3                   	retq   

0000000000804991 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804991:	55                   	push   %rbp
  804992:	48 89 e5             	mov    %rsp,%rbp
  804995:	48 83 ec 20          	sub    $0x20,%rsp
  804999:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80499d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8049a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049a5:	48 89 c7             	mov    %rax,%rdi
  8049a8:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  8049af:	00 00 00 
  8049b2:	ff d0                	callq  *%rax
  8049b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8049b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049bc:	48 be f0 5e 80 00 00 	movabs $0x805ef0,%rsi
  8049c3:	00 00 00 
  8049c6:	48 89 c7             	mov    %rax,%rdi
  8049c9:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8049d0:	00 00 00 
  8049d3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8049d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049d9:	8b 50 04             	mov    0x4(%rax),%edx
  8049dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049e0:	8b 00                	mov    (%rax),%eax
  8049e2:	29 c2                	sub    %eax,%edx
  8049e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049e8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8049ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049f2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8049f9:	00 00 00 
	stat->st_dev = &devpipe;
  8049fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a00:	48 b9 40 81 80 00 00 	movabs $0x808140,%rcx
  804a07:	00 00 00 
  804a0a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a16:	c9                   	leaveq 
  804a17:	c3                   	retq   

0000000000804a18 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804a18:	55                   	push   %rbp
  804a19:	48 89 e5             	mov    %rsp,%rbp
  804a1c:	48 83 ec 10          	sub    $0x10,%rsp
  804a20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804a24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a28:	48 89 c6             	mov    %rax,%rsi
  804a2b:	bf 00 00 00 00       	mov    $0x0,%edi
  804a30:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  804a37:	00 00 00 
  804a3a:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804a3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a40:	48 89 c7             	mov    %rax,%rdi
  804a43:	48 b8 fe 26 80 00 00 	movabs $0x8026fe,%rax
  804a4a:	00 00 00 
  804a4d:	ff d0                	callq  *%rax
  804a4f:	48 89 c6             	mov    %rax,%rsi
  804a52:	bf 00 00 00 00       	mov    $0x0,%edi
  804a57:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  804a5e:	00 00 00 
  804a61:	ff d0                	callq  *%rax
}
  804a63:	c9                   	leaveq 
  804a64:	c3                   	retq   

0000000000804a65 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804a65:	55                   	push   %rbp
  804a66:	48 89 e5             	mov    %rsp,%rbp
  804a69:	48 83 ec 20          	sub    $0x20,%rsp
  804a6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804a70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a73:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804a76:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804a7a:	be 01 00 00 00       	mov    $0x1,%esi
  804a7f:	48 89 c7             	mov    %rax,%rdi
  804a82:	48 b8 b3 21 80 00 00 	movabs $0x8021b3,%rax
  804a89:	00 00 00 
  804a8c:	ff d0                	callq  *%rax
}
  804a8e:	c9                   	leaveq 
  804a8f:	c3                   	retq   

0000000000804a90 <getchar>:

int
getchar(void)
{
  804a90:	55                   	push   %rbp
  804a91:	48 89 e5             	mov    %rsp,%rbp
  804a94:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804a98:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804a9c:	ba 01 00 00 00       	mov    $0x1,%edx
  804aa1:	48 89 c6             	mov    %rax,%rsi
  804aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  804aa9:	48 b8 f3 2b 80 00 00 	movabs $0x802bf3,%rax
  804ab0:	00 00 00 
  804ab3:	ff d0                	callq  *%rax
  804ab5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804abc:	79 05                	jns    804ac3 <getchar+0x33>
		return r;
  804abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ac1:	eb 14                	jmp    804ad7 <getchar+0x47>
	if (r < 1)
  804ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ac7:	7f 07                	jg     804ad0 <getchar+0x40>
		return -E_EOF;
  804ac9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804ace:	eb 07                	jmp    804ad7 <getchar+0x47>
	return c;
  804ad0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804ad4:	0f b6 c0             	movzbl %al,%eax

}
  804ad7:	c9                   	leaveq 
  804ad8:	c3                   	retq   

0000000000804ad9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804ad9:	55                   	push   %rbp
  804ada:	48 89 e5             	mov    %rsp,%rbp
  804add:	48 83 ec 20          	sub    $0x20,%rsp
  804ae1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804ae4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804ae8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804aeb:	48 89 d6             	mov    %rdx,%rsi
  804aee:	89 c7                	mov    %eax,%edi
  804af0:	48 b8 c1 27 80 00 00 	movabs $0x8027c1,%rax
  804af7:	00 00 00 
  804afa:	ff d0                	callq  *%rax
  804afc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b03:	79 05                	jns    804b0a <iscons+0x31>
		return r;
  804b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b08:	eb 1a                	jmp    804b24 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b0e:	8b 10                	mov    (%rax),%edx
  804b10:	48 b8 80 81 80 00 00 	movabs $0x808180,%rax
  804b17:	00 00 00 
  804b1a:	8b 00                	mov    (%rax),%eax
  804b1c:	39 c2                	cmp    %eax,%edx
  804b1e:	0f 94 c0             	sete   %al
  804b21:	0f b6 c0             	movzbl %al,%eax
}
  804b24:	c9                   	leaveq 
  804b25:	c3                   	retq   

0000000000804b26 <opencons>:

int
opencons(void)
{
  804b26:	55                   	push   %rbp
  804b27:	48 89 e5             	mov    %rsp,%rbp
  804b2a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804b2e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804b32:	48 89 c7             	mov    %rax,%rdi
  804b35:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  804b3c:	00 00 00 
  804b3f:	ff d0                	callq  *%rax
  804b41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b48:	79 05                	jns    804b4f <opencons+0x29>
		return r;
  804b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b4d:	eb 5b                	jmp    804baa <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b53:	ba 07 04 00 00       	mov    $0x407,%edx
  804b58:	48 89 c6             	mov    %rax,%rsi
  804b5b:	bf 00 00 00 00       	mov    $0x0,%edi
  804b60:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  804b67:	00 00 00 
  804b6a:	ff d0                	callq  *%rax
  804b6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b73:	79 05                	jns    804b7a <opencons+0x54>
		return r;
  804b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b78:	eb 30                	jmp    804baa <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b7e:	48 ba 80 81 80 00 00 	movabs $0x808180,%rdx
  804b85:	00 00 00 
  804b88:	8b 12                	mov    (%rdx),%edx
  804b8a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804b8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b90:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804b97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b9b:	48 89 c7             	mov    %rax,%rdi
  804b9e:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  804ba5:	00 00 00 
  804ba8:	ff d0                	callq  *%rax
}
  804baa:	c9                   	leaveq 
  804bab:	c3                   	retq   

0000000000804bac <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804bac:	55                   	push   %rbp
  804bad:	48 89 e5             	mov    %rsp,%rbp
  804bb0:	48 83 ec 30          	sub    $0x30,%rsp
  804bb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804bb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804bbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804bc0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804bc5:	75 07                	jne    804bce <devcons_read+0x22>
		return 0;
  804bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  804bcc:	eb 4b                	jmp    804c19 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804bce:	eb 0c                	jmp    804bdc <devcons_read+0x30>
		sys_yield();
  804bd0:	48 b8 bd 22 80 00 00 	movabs $0x8022bd,%rax
  804bd7:	00 00 00 
  804bda:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804bdc:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  804be3:	00 00 00 
  804be6:	ff d0                	callq  *%rax
  804be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804beb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bef:	74 df                	je     804bd0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bf5:	79 05                	jns    804bfc <devcons_read+0x50>
		return c;
  804bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bfa:	eb 1d                	jmp    804c19 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804bfc:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804c00:	75 07                	jne    804c09 <devcons_read+0x5d>
		return 0;
  804c02:	b8 00 00 00 00       	mov    $0x0,%eax
  804c07:	eb 10                	jmp    804c19 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c0c:	89 c2                	mov    %eax,%edx
  804c0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c12:	88 10                	mov    %dl,(%rax)
	return 1;
  804c14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804c19:	c9                   	leaveq 
  804c1a:	c3                   	retq   

0000000000804c1b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804c1b:	55                   	push   %rbp
  804c1c:	48 89 e5             	mov    %rsp,%rbp
  804c1f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804c26:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804c2d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804c34:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804c3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c42:	eb 76                	jmp    804cba <devcons_write+0x9f>
		m = n - tot;
  804c44:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804c4b:	89 c2                	mov    %eax,%edx
  804c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c50:	29 c2                	sub    %eax,%edx
  804c52:	89 d0                	mov    %edx,%eax
  804c54:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804c57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c5a:	83 f8 7f             	cmp    $0x7f,%eax
  804c5d:	76 07                	jbe    804c66 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804c5f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804c66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c69:	48 63 d0             	movslq %eax,%rdx
  804c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c6f:	48 63 c8             	movslq %eax,%rcx
  804c72:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804c79:	48 01 c1             	add    %rax,%rcx
  804c7c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804c83:	48 89 ce             	mov    %rcx,%rsi
  804c86:	48 89 c7             	mov    %rax,%rdi
  804c89:	48 b8 f0 1c 80 00 00 	movabs $0x801cf0,%rax
  804c90:	00 00 00 
  804c93:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804c95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c98:	48 63 d0             	movslq %eax,%rdx
  804c9b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804ca2:	48 89 d6             	mov    %rdx,%rsi
  804ca5:	48 89 c7             	mov    %rax,%rdi
  804ca8:	48 b8 b3 21 80 00 00 	movabs $0x8021b3,%rax
  804caf:	00 00 00 
  804cb2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804cb4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804cb7:	01 45 fc             	add    %eax,-0x4(%rbp)
  804cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cbd:	48 98                	cltq   
  804cbf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804cc6:	0f 82 78 ff ff ff    	jb     804c44 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804ccf:	c9                   	leaveq 
  804cd0:	c3                   	retq   

0000000000804cd1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804cd1:	55                   	push   %rbp
  804cd2:	48 89 e5             	mov    %rsp,%rbp
  804cd5:	48 83 ec 08          	sub    $0x8,%rsp
  804cd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ce2:	c9                   	leaveq 
  804ce3:	c3                   	retq   

0000000000804ce4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804ce4:	55                   	push   %rbp
  804ce5:	48 89 e5             	mov    %rsp,%rbp
  804ce8:	48 83 ec 10          	sub    $0x10,%rsp
  804cec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804cf0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cf8:	48 be fc 5e 80 00 00 	movabs $0x805efc,%rsi
  804cff:	00 00 00 
  804d02:	48 89 c7             	mov    %rax,%rdi
  804d05:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  804d0c:	00 00 00 
  804d0f:	ff d0                	callq  *%rax
	return 0;
  804d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d16:	c9                   	leaveq 
  804d17:	c3                   	retq   

0000000000804d18 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804d18:	55                   	push   %rbp
  804d19:	48 89 e5             	mov    %rsp,%rbp
  804d1c:	48 83 ec 30          	sub    $0x30,%rsp
  804d20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804d28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804d2c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804d31:	75 0e                	jne    804d41 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804d33:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d3a:	00 00 00 
  804d3d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804d41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d45:	48 89 c7             	mov    %rax,%rdi
  804d48:	48 b8 24 25 80 00 00 	movabs $0x802524,%rax
  804d4f:	00 00 00 
  804d52:	ff d0                	callq  *%rax
  804d54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d5b:	79 27                	jns    804d84 <ipc_recv+0x6c>
		if (from_env_store)
  804d5d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804d62:	74 0a                	je     804d6e <ipc_recv+0x56>
			*from_env_store = 0;
  804d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d68:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804d6e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d73:	74 0a                	je     804d7f <ipc_recv+0x67>
			*perm_store = 0;
  804d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d79:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804d7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d82:	eb 53                	jmp    804dd7 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804d84:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804d89:	74 19                	je     804da4 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804d8b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804d92:	00 00 00 
  804d95:	48 8b 00             	mov    (%rax),%rax
  804d98:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804da2:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804da4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804da9:	74 19                	je     804dc4 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804dab:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804db2:	00 00 00 
  804db5:	48 8b 00             	mov    (%rax),%rax
  804db8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804dbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dc2:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804dc4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804dcb:	00 00 00 
  804dce:	48 8b 00             	mov    (%rax),%rax
  804dd1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804dd7:	c9                   	leaveq 
  804dd8:	c3                   	retq   

0000000000804dd9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804dd9:	55                   	push   %rbp
  804dda:	48 89 e5             	mov    %rsp,%rbp
  804ddd:	48 83 ec 30          	sub    $0x30,%rsp
  804de1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804de4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804de7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804deb:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804dee:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804df3:	75 10                	jne    804e05 <ipc_send+0x2c>
		pg = (void*) UTOP;
  804df5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804dfc:	00 00 00 
  804dff:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804e03:	eb 0e                	jmp    804e13 <ipc_send+0x3a>
  804e05:	eb 0c                	jmp    804e13 <ipc_send+0x3a>
		sys_yield();
  804e07:	48 b8 bd 22 80 00 00 	movabs $0x8022bd,%rax
  804e0e:	00 00 00 
  804e11:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804e13:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804e16:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804e19:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804e1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e20:	89 c7                	mov    %eax,%edi
  804e22:	48 b8 cf 24 80 00 00 	movabs $0x8024cf,%rax
  804e29:	00 00 00 
  804e2c:	ff d0                	callq  *%rax
  804e2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e31:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804e35:	74 d0                	je     804e07 <ipc_send+0x2e>
		sys_yield();
	}
	if (r < 0)
  804e37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e3b:	79 30                	jns    804e6d <ipc_send+0x94>
		panic("error in ipc_send: %e", r);
  804e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e40:	89 c1                	mov    %eax,%ecx
  804e42:	48 ba 03 5f 80 00 00 	movabs $0x805f03,%rdx
  804e49:	00 00 00 
  804e4c:	be 47 00 00 00       	mov    $0x47,%esi
  804e51:	48 bf 19 5f 80 00 00 	movabs $0x805f19,%rdi
  804e58:	00 00 00 
  804e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  804e60:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  804e67:	00 00 00 
  804e6a:	41 ff d0             	callq  *%r8

}
  804e6d:	c9                   	leaveq 
  804e6e:	c3                   	retq   

0000000000804e6f <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804e6f:	55                   	push   %rbp
  804e70:	48 89 e5             	mov    %rsp,%rbp
  804e73:	53                   	push   %rbx
  804e74:	48 83 ec 28          	sub    $0x28,%rsp
  804e78:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  804e7c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804e83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804e8a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804e8f:	75 0e                	jne    804e9f <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804e91:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e98:	00 00 00 
  804e9b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804e9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ea3:	ba 07 00 00 00       	mov    $0x7,%edx
  804ea8:	48 89 c6             	mov    %rax,%rsi
  804eab:	bf 00 00 00 00       	mov    $0x0,%edi
  804eb0:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  804eb7:	00 00 00 
  804eba:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804ebc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ec0:	48 c1 e8 0c          	shr    $0xc,%rax
  804ec4:	48 89 c2             	mov    %rax,%rdx
  804ec7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ece:	01 00 00 
  804ed1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ed5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804edb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804edf:	b8 03 00 00 00       	mov    $0x3,%eax
  804ee4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804ee8:	48 89 d3             	mov    %rdx,%rbx
  804eeb:	0f 01 c1             	vmcall 
  804eee:	89 f2                	mov    %esi,%edx
  804ef0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804ef3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	/* cprintf("Returned IPC response from host: %d %d\n", r, -val);*/
	if (r < 0) {
  804ef6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804efa:	79 05                	jns    804f01 <ipc_host_recv+0x92>
		return r;
  804efc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804eff:	eb 03                	jmp    804f04 <ipc_host_recv+0x95>
	}
	return val;
  804f01:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804f04:	48 83 c4 28          	add    $0x28,%rsp
  804f08:	5b                   	pop    %rbx
  804f09:	5d                   	pop    %rbp
  804f0a:	c3                   	retq   

0000000000804f0b <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804f0b:	55                   	push   %rbp
  804f0c:	48 89 e5             	mov    %rsp,%rbp
  804f0f:	53                   	push   %rbx
  804f10:	48 83 ec 38          	sub    $0x38,%rsp
  804f14:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804f17:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804f1a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804f1e:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804f21:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804f28:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804f2d:	75 0e                	jne    804f3d <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804f2f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804f36:	00 00 00 
  804f39:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804f3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f41:	48 c1 e8 0c          	shr    $0xc,%rax
  804f45:	48 89 c2             	mov    %rax,%rdx
  804f48:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f4f:	01 00 00 
  804f52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f56:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804f5c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804f60:	b8 02 00 00 00       	mov    $0x2,%eax
  804f65:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804f68:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804f6b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804f6f:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804f72:	89 fb                	mov    %edi,%ebx
  804f74:	0f 01 c1             	vmcall 
  804f77:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804f7a:	eb 26                	jmp    804fa2 <ipc_host_send+0x97>
		sys_yield();
  804f7c:	48 b8 bd 22 80 00 00 	movabs $0x8022bd,%rax
  804f83:	00 00 00 
  804f86:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804f88:	b8 02 00 00 00       	mov    $0x2,%eax
  804f8d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804f90:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804f93:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804f97:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804f9a:	89 fb                	mov    %edi,%ebx
  804f9c:	0f 01 c1             	vmcall 
  804f9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804fa2:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804fa6:	74 d4                	je     804f7c <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804fa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fac:	79 30                	jns    804fde <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804fae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fb1:	89 c1                	mov    %eax,%ecx
  804fb3:	48 ba 03 5f 80 00 00 	movabs $0x805f03,%rdx
  804fba:	00 00 00 
  804fbd:	be 79 00 00 00       	mov    $0x79,%esi
  804fc2:	48 bf 19 5f 80 00 00 	movabs $0x805f19,%rdi
  804fc9:	00 00 00 
  804fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  804fd1:	49 b8 de 0b 80 00 00 	movabs $0x800bde,%r8
  804fd8:	00 00 00 
  804fdb:	41 ff d0             	callq  *%r8

}
  804fde:	48 83 c4 38          	add    $0x38,%rsp
  804fe2:	5b                   	pop    %rbx
  804fe3:	5d                   	pop    %rbp
  804fe4:	c3                   	retq   

0000000000804fe5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804fe5:	55                   	push   %rbp
  804fe6:	48 89 e5             	mov    %rsp,%rbp
  804fe9:	48 83 ec 14          	sub    $0x14,%rsp
  804fed:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804ff0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ff7:	eb 4e                	jmp    805047 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804ff9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805000:	00 00 00 
  805003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805006:	48 98                	cltq   
  805008:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80500f:	48 01 d0             	add    %rdx,%rax
  805012:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805018:	8b 00                	mov    (%rax),%eax
  80501a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80501d:	75 24                	jne    805043 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80501f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805026:	00 00 00 
  805029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80502c:	48 98                	cltq   
  80502e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805035:	48 01 d0             	add    %rdx,%rax
  805038:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80503e:	8b 40 08             	mov    0x8(%rax),%eax
  805041:	eb 12                	jmp    805055 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805043:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805047:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80504e:	7e a9                	jle    804ff9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805050:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805055:	c9                   	leaveq 
  805056:	c3                   	retq   

0000000000805057 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  805057:	55                   	push   %rbp
  805058:	48 89 e5             	mov    %rsp,%rbp
  80505b:	48 83 ec 18          	sub    $0x18,%rsp
  80505f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805063:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805067:	48 c1 e8 15          	shr    $0x15,%rax
  80506b:	48 89 c2             	mov    %rax,%rdx
  80506e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805075:	01 00 00 
  805078:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80507c:	83 e0 01             	and    $0x1,%eax
  80507f:	48 85 c0             	test   %rax,%rax
  805082:	75 07                	jne    80508b <pageref+0x34>
		return 0;
  805084:	b8 00 00 00 00       	mov    $0x0,%eax
  805089:	eb 53                	jmp    8050de <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80508b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80508f:	48 c1 e8 0c          	shr    $0xc,%rax
  805093:	48 89 c2             	mov    %rax,%rdx
  805096:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80509d:	01 00 00 
  8050a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8050a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050ac:	83 e0 01             	and    $0x1,%eax
  8050af:	48 85 c0             	test   %rax,%rax
  8050b2:	75 07                	jne    8050bb <pageref+0x64>
		return 0;
  8050b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8050b9:	eb 23                	jmp    8050de <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8050bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8050c3:	48 89 c2             	mov    %rax,%rdx
  8050c6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8050cd:	00 00 00 
  8050d0:	48 c1 e2 04          	shl    $0x4,%rdx
  8050d4:	48 01 d0             	add    %rdx,%rax
  8050d7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8050db:	0f b7 c0             	movzwl %ax,%eax
}
  8050de:	c9                   	leaveq 
  8050df:	c3                   	retq   

00000000008050e0 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8050e0:	55                   	push   %rbp
  8050e1:	48 89 e5             	mov    %rsp,%rbp
  8050e4:	48 83 ec 20          	sub    $0x20,%rsp
  8050e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8050ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8050f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050f4:	48 89 d6             	mov    %rdx,%rsi
  8050f7:	48 89 c7             	mov    %rax,%rdi
  8050fa:	48 b8 16 51 80 00 00 	movabs $0x805116,%rax
  805101:	00 00 00 
  805104:	ff d0                	callq  *%rax
  805106:	85 c0                	test   %eax,%eax
  805108:	74 05                	je     80510f <inet_addr+0x2f>
    return (val.s_addr);
  80510a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80510d:	eb 05                	jmp    805114 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  80510f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  805114:	c9                   	leaveq 
  805115:	c3                   	retq   

0000000000805116 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  805116:	55                   	push   %rbp
  805117:	48 89 e5             	mov    %rsp,%rbp
  80511a:	48 83 ec 40          	sub    $0x40,%rsp
  80511e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  805122:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  805126:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80512a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  80512e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805132:	0f b6 00             	movzbl (%rax),%eax
  805135:	0f be c0             	movsbl %al,%eax
  805138:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  80513b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80513e:	3c 2f                	cmp    $0x2f,%al
  805140:	76 07                	jbe    805149 <inet_aton+0x33>
  805142:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805145:	3c 39                	cmp    $0x39,%al
  805147:	76 0a                	jbe    805153 <inet_aton+0x3d>
      return (0);
  805149:	b8 00 00 00 00       	mov    $0x0,%eax
  80514e:	e9 68 02 00 00       	jmpq   8053bb <inet_aton+0x2a5>
    val = 0;
  805153:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  80515a:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  805161:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  805165:	75 40                	jne    8051a7 <inet_aton+0x91>
      c = *++cp;
  805167:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80516c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805170:	0f b6 00             	movzbl (%rax),%eax
  805173:	0f be c0             	movsbl %al,%eax
  805176:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  805179:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  80517d:	74 06                	je     805185 <inet_aton+0x6f>
  80517f:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  805183:	75 1b                	jne    8051a0 <inet_aton+0x8a>
        base = 16;
  805185:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  80518c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805191:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805195:	0f b6 00             	movzbl (%rax),%eax
  805198:	0f be c0             	movsbl %al,%eax
  80519b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80519e:	eb 07                	jmp    8051a7 <inet_aton+0x91>
      } else
        base = 8;
  8051a0:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  8051a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051aa:	3c 2f                	cmp    $0x2f,%al
  8051ac:	76 2f                	jbe    8051dd <inet_aton+0xc7>
  8051ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051b1:	3c 39                	cmp    $0x39,%al
  8051b3:	77 28                	ja     8051dd <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  8051b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8051b8:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  8051bc:	89 c2                	mov    %eax,%edx
  8051be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051c1:	01 d0                	add    %edx,%eax
  8051c3:	83 e8 30             	sub    $0x30,%eax
  8051c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8051c9:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8051ce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8051d2:	0f b6 00             	movzbl (%rax),%eax
  8051d5:	0f be c0             	movsbl %al,%eax
  8051d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  8051db:	eb ca                	jmp    8051a7 <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  8051dd:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  8051e1:	75 72                	jne    805255 <inet_aton+0x13f>
  8051e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051e6:	3c 2f                	cmp    $0x2f,%al
  8051e8:	76 07                	jbe    8051f1 <inet_aton+0xdb>
  8051ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051ed:	3c 39                	cmp    $0x39,%al
  8051ef:	76 1c                	jbe    80520d <inet_aton+0xf7>
  8051f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051f4:	3c 60                	cmp    $0x60,%al
  8051f6:	76 07                	jbe    8051ff <inet_aton+0xe9>
  8051f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051fb:	3c 66                	cmp    $0x66,%al
  8051fd:	76 0e                	jbe    80520d <inet_aton+0xf7>
  8051ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805202:	3c 40                	cmp    $0x40,%al
  805204:	76 4f                	jbe    805255 <inet_aton+0x13f>
  805206:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805209:	3c 46                	cmp    $0x46,%al
  80520b:	77 48                	ja     805255 <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  80520d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805210:	c1 e0 04             	shl    $0x4,%eax
  805213:	89 c2                	mov    %eax,%edx
  805215:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805218:	8d 48 0a             	lea    0xa(%rax),%ecx
  80521b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80521e:	3c 60                	cmp    $0x60,%al
  805220:	76 0e                	jbe    805230 <inet_aton+0x11a>
  805222:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805225:	3c 7a                	cmp    $0x7a,%al
  805227:	77 07                	ja     805230 <inet_aton+0x11a>
  805229:	b8 61 00 00 00       	mov    $0x61,%eax
  80522e:	eb 05                	jmp    805235 <inet_aton+0x11f>
  805230:	b8 41 00 00 00       	mov    $0x41,%eax
  805235:	29 c1                	sub    %eax,%ecx
  805237:	89 c8                	mov    %ecx,%eax
  805239:	09 d0                	or     %edx,%eax
  80523b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80523e:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805243:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805247:	0f b6 00             	movzbl (%rax),%eax
  80524a:	0f be c0             	movsbl %al,%eax
  80524d:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  805250:	e9 52 ff ff ff       	jmpq   8051a7 <inet_aton+0x91>
    if (c == '.') {
  805255:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  805259:	75 40                	jne    80529b <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80525b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80525f:	48 83 c0 0c          	add    $0xc,%rax
  805263:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  805267:	72 0a                	jb     805273 <inet_aton+0x15d>
        return (0);
  805269:	b8 00 00 00 00       	mov    $0x0,%eax
  80526e:	e9 48 01 00 00       	jmpq   8053bb <inet_aton+0x2a5>
      *pp++ = val;
  805273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805277:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80527b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80527f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805282:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  805284:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805289:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80528d:	0f b6 00             	movzbl (%rax),%eax
  805290:	0f be c0             	movsbl %al,%eax
  805293:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  805296:	e9 a0 fe ff ff       	jmpq   80513b <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  80529b:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80529c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8052a0:	74 3c                	je     8052de <inet_aton+0x1c8>
  8052a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052a5:	3c 1f                	cmp    $0x1f,%al
  8052a7:	76 2b                	jbe    8052d4 <inet_aton+0x1be>
  8052a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052ac:	84 c0                	test   %al,%al
  8052ae:	78 24                	js     8052d4 <inet_aton+0x1be>
  8052b0:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  8052b4:	74 28                	je     8052de <inet_aton+0x1c8>
  8052b6:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  8052ba:	74 22                	je     8052de <inet_aton+0x1c8>
  8052bc:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8052c0:	74 1c                	je     8052de <inet_aton+0x1c8>
  8052c2:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8052c6:	74 16                	je     8052de <inet_aton+0x1c8>
  8052c8:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  8052cc:	74 10                	je     8052de <inet_aton+0x1c8>
  8052ce:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  8052d2:	74 0a                	je     8052de <inet_aton+0x1c8>
    return (0);
  8052d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8052d9:	e9 dd 00 00 00       	jmpq   8053bb <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8052de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8052e2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8052e6:	48 29 c2             	sub    %rax,%rdx
  8052e9:	48 89 d0             	mov    %rdx,%rax
  8052ec:	48 c1 f8 02          	sar    $0x2,%rax
  8052f0:	83 c0 01             	add    $0x1,%eax
  8052f3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  8052f6:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  8052fa:	0f 87 98 00 00 00    	ja     805398 <inet_aton+0x282>
  805300:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  805303:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80530a:	00 
  80530b:	48 b8 28 5f 80 00 00 	movabs $0x805f28,%rax
  805312:	00 00 00 
  805315:	48 01 d0             	add    %rdx,%rax
  805318:	48 8b 00             	mov    (%rax),%rax
  80531b:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  80531d:	b8 00 00 00 00       	mov    $0x0,%eax
  805322:	e9 94 00 00 00       	jmpq   8053bb <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  805327:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  80532e:	76 0a                	jbe    80533a <inet_aton+0x224>
      return (0);
  805330:	b8 00 00 00 00       	mov    $0x0,%eax
  805335:	e9 81 00 00 00       	jmpq   8053bb <inet_aton+0x2a5>
    val |= parts[0] << 24;
  80533a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80533d:	c1 e0 18             	shl    $0x18,%eax
  805340:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  805343:	eb 53                	jmp    805398 <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  805345:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  80534c:	76 07                	jbe    805355 <inet_aton+0x23f>
      return (0);
  80534e:	b8 00 00 00 00       	mov    $0x0,%eax
  805353:	eb 66                	jmp    8053bb <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  805355:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805358:	c1 e0 18             	shl    $0x18,%eax
  80535b:	89 c2                	mov    %eax,%edx
  80535d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  805360:	c1 e0 10             	shl    $0x10,%eax
  805363:	09 d0                	or     %edx,%eax
  805365:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  805368:	eb 2e                	jmp    805398 <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80536a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  805371:	76 07                	jbe    80537a <inet_aton+0x264>
      return (0);
  805373:	b8 00 00 00 00       	mov    $0x0,%eax
  805378:	eb 41                	jmp    8053bb <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80537a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80537d:	c1 e0 18             	shl    $0x18,%eax
  805380:	89 c2                	mov    %eax,%edx
  805382:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  805385:	c1 e0 10             	shl    $0x10,%eax
  805388:	09 c2                	or     %eax,%edx
  80538a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80538d:	c1 e0 08             	shl    $0x8,%eax
  805390:	09 d0                	or     %edx,%eax
  805392:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  805395:	eb 01                	jmp    805398 <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  805397:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  805398:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  80539d:	74 17                	je     8053b6 <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  80539f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053a2:	89 c7                	mov    %eax,%edi
  8053a4:	48 b8 34 55 80 00 00 	movabs $0x805534,%rax
  8053ab:	00 00 00 
  8053ae:	ff d0                	callq  *%rax
  8053b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8053b4:	89 02                	mov    %eax,(%rdx)
  return (1);
  8053b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8053bb:	c9                   	leaveq 
  8053bc:	c3                   	retq   

00000000008053bd <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8053bd:	55                   	push   %rbp
  8053be:	48 89 e5             	mov    %rsp,%rbp
  8053c1:	48 83 ec 30          	sub    $0x30,%rsp
  8053c5:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8053c8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8053cb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  8053ce:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  8053d5:	00 00 00 
  8053d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8053dc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8053e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8053e4:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8053e8:	e9 e0 00 00 00       	jmpq   8054cd <inet_ntoa+0x110>
    i = 0;
  8053ed:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8053f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053f5:	0f b6 08             	movzbl (%rax),%ecx
  8053f8:	0f b6 d1             	movzbl %cl,%edx
  8053fb:	89 d0                	mov    %edx,%eax
  8053fd:	c1 e0 02             	shl    $0x2,%eax
  805400:	01 d0                	add    %edx,%eax
  805402:	c1 e0 03             	shl    $0x3,%eax
  805405:	01 d0                	add    %edx,%eax
  805407:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  80540e:	01 d0                	add    %edx,%eax
  805410:	66 c1 e8 08          	shr    $0x8,%ax
  805414:	c0 e8 03             	shr    $0x3,%al
  805417:	88 45 ed             	mov    %al,-0x13(%rbp)
  80541a:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80541e:	89 d0                	mov    %edx,%eax
  805420:	c1 e0 02             	shl    $0x2,%eax
  805423:	01 d0                	add    %edx,%eax
  805425:	01 c0                	add    %eax,%eax
  805427:	29 c1                	sub    %eax,%ecx
  805429:	89 c8                	mov    %ecx,%eax
  80542b:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  80542e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805432:	0f b6 00             	movzbl (%rax),%eax
  805435:	0f b6 d0             	movzbl %al,%edx
  805438:	89 d0                	mov    %edx,%eax
  80543a:	c1 e0 02             	shl    $0x2,%eax
  80543d:	01 d0                	add    %edx,%eax
  80543f:	c1 e0 03             	shl    $0x3,%eax
  805442:	01 d0                	add    %edx,%eax
  805444:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  80544b:	01 d0                	add    %edx,%eax
  80544d:	66 c1 e8 08          	shr    $0x8,%ax
  805451:	89 c2                	mov    %eax,%edx
  805453:	c0 ea 03             	shr    $0x3,%dl
  805456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80545a:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  80545c:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805460:	8d 50 01             	lea    0x1(%rax),%edx
  805463:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805466:	0f b6 c0             	movzbl %al,%eax
  805469:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80546d:	83 c2 30             	add    $0x30,%edx
  805470:	48 98                	cltq   
  805472:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  805476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80547a:	0f b6 00             	movzbl (%rax),%eax
  80547d:	84 c0                	test   %al,%al
  80547f:	0f 85 6c ff ff ff    	jne    8053f1 <inet_ntoa+0x34>
    while(i--)
  805485:	eb 1a                	jmp    8054a1 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  805487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80548b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80548f:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805493:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  805497:	48 63 d2             	movslq %edx,%rdx
  80549a:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  80549f:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8054a1:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8054a5:	8d 50 ff             	lea    -0x1(%rax),%edx
  8054a8:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8054ab:	84 c0                	test   %al,%al
  8054ad:	75 d8                	jne    805487 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  8054af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8054b7:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8054bb:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  8054be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8054c3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8054c7:	83 c0 01             	add    $0x1,%eax
  8054ca:	88 45 ef             	mov    %al,-0x11(%rbp)
  8054cd:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  8054d1:	0f 86 16 ff ff ff    	jbe    8053ed <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  8054d7:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8054dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054e0:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8054e3:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  8054ea:	00 00 00 
}
  8054ed:	c9                   	leaveq 
  8054ee:	c3                   	retq   

00000000008054ef <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8054ef:	55                   	push   %rbp
  8054f0:	48 89 e5             	mov    %rsp,%rbp
  8054f3:	48 83 ec 04          	sub    $0x4,%rsp
  8054f7:	89 f8                	mov    %edi,%eax
  8054f9:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8054fd:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805501:	c1 e0 08             	shl    $0x8,%eax
  805504:	89 c2                	mov    %eax,%edx
  805506:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80550a:	66 c1 e8 08          	shr    $0x8,%ax
  80550e:	09 d0                	or     %edx,%eax
}
  805510:	c9                   	leaveq 
  805511:	c3                   	retq   

0000000000805512 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  805512:	55                   	push   %rbp
  805513:	48 89 e5             	mov    %rsp,%rbp
  805516:	48 83 ec 08          	sub    $0x8,%rsp
  80551a:	89 f8                	mov    %edi,%eax
  80551c:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  805520:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805524:	89 c7                	mov    %eax,%edi
  805526:	48 b8 ef 54 80 00 00 	movabs $0x8054ef,%rax
  80552d:	00 00 00 
  805530:	ff d0                	callq  *%rax
}
  805532:	c9                   	leaveq 
  805533:	c3                   	retq   

0000000000805534 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  805534:	55                   	push   %rbp
  805535:	48 89 e5             	mov    %rsp,%rbp
  805538:	48 83 ec 04          	sub    $0x4,%rsp
  80553c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80553f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805542:	c1 e0 18             	shl    $0x18,%eax
  805545:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  805547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80554a:	25 00 ff 00 00       	and    $0xff00,%eax
  80554f:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805552:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  805554:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805557:	25 00 00 ff 00       	and    $0xff0000,%eax
  80555c:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805560:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  805562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805565:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805568:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80556a:	c9                   	leaveq 
  80556b:	c3                   	retq   

000000000080556c <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80556c:	55                   	push   %rbp
  80556d:	48 89 e5             	mov    %rsp,%rbp
  805570:	48 83 ec 08          	sub    $0x8,%rsp
  805574:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  805577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80557a:	89 c7                	mov    %eax,%edi
  80557c:	48 b8 34 55 80 00 00 	movabs $0x805534,%rax
  805583:	00 00 00 
  805586:	ff d0                	callq  *%rax
}
  805588:	c9                   	leaveq 
  805589:	c3                   	retq   
