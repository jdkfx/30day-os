void io_hlt(void);
void write_mem8(int addr, int data);

void HariMain(void)
{
	int i; /* 32ビットの整数型 */
	char *p; /* BYTE[...]用の番地 */

	for(i = 0xa0000; i <= 0xaffff; i++) {

		p = (char *) i; /* 番地を代入 */
		*p = i & 0x0f;

		/* 上のコードが write_mem8(i, i & 0x0f); の代わりになる */
	}

	for(;;) {
		io_hlt();
	}
}
