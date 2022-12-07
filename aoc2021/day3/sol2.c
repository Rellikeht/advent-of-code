#include <stdio.h>
#include <stdlib.h>

typedef unsigned long long btype;

typedef struct node {
	btype num;
	struct node *next;
} node;

int main() {
	char buf[sizeof(btype)*8] = {0};
	int amounts[sizeof(btype)*8] = {0};
	int i = 0, lines = 0, delem;
	node *numlist = NULL, nlel;

	while (!feof(stdin)) {
		scanf("%s", buf);
		nlel = (node){.num=atoi(buf), .next=numlist};
		numlist = &nlel;

		while (buf[i] != 0) {
			amounts[i] += buf[i]-'0';
			i++;
		}

		lines++;
		i = 0;
	}

	lines >>= 1;
	btype oxval = 0;

	while (buf[i] != 0) {
		oxval <<= 1;
		if (amounts[i] >= lines)
			oxval += 1;
		i++;
	}
	btype byte = 1<<(i-1), co2val = (1<<i) - oxval-1;
	//printf("%llu %llu %llu\n", endval, ev2, endval*ev2);

	node *cnode = numlist;
	while (cnode->next != NULL) {
		if ((cnode->num&byte) == (oxval&byte)) {
		}
	}
	byte >>= 1;

	return 0;
}
