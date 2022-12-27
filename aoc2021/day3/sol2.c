#include <stdio.h>
#include <stdbool.h>

typedef unsigned long long btype;
#define START_LEN 1024
#define BSIZE sizeof(btype)*8

btype latoi(char *chs) {
    btype retv = 0;
    int i = 0;
    while (chs[i] != 0) {
	retv <<= 1;
	retv += chs[i]-'0';
	i++;
    }
    return retv;
}

btype mcb(btype *elems, int amount, btype bit, bool neg) {
    int bits = 0;
    for (int i = 0; i < amount; i++) {
	if ((elems[i]&bit) == bit) bits += 1;
	else bits -= 1;
    }

    if (bits >= 0 && !neg || bits < 0 && neg) return bit;
    return 0;
}

btype passing(btype *elems, int len, int sbit, bool neg) {
	int i = 0, j = 0;
	int clen;
	btype bit = 1<<sbit;
	btype common = 0;

	while (len > 1) {
	    bit >>= 1;
	    clen = len;
	    j = 0;
	    common = mcb(elems, len, bit, neg);

	    for (i = 0; i < clen; i++) {
		if ((elems[i]&bit) == common) {
		    elems[j] = elems[i];
		    j++;
		} else len--;
	    }
	}

	return elems[0];
}

int main() {
	char buf[BSIZE] = {0};
	int amounts[BSIZE] = {0};
	int lines = 0, llen = 0;
	btype oelems[START_LEN] = {0};
	btype celems[START_LEN] = {0};

	while (!feof(stdin)) {
		scanf("%s\n", buf);
		oelems[lines] = latoi(buf);
		celems[lines] = oelems[lines];
		lines++;
	}

	int blen = 0;
	while (buf[blen]) blen++;
	btype omax = passing(oelems, lines, blen, false);
	btype cmax = passing(celems, lines, blen, true);

	printf("%llu %llu : %llu\n", omax, cmax, omax*cmax);
	return 0;
}
