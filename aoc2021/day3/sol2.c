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
	node *numlist = NULL;

	while (!feof(stdin)) {
		scanf("%s\n", buf);
		//node newel = (node){.num=atoll(buf), .next=numlist};
		//numlist = &newel;
		numlist = &(node){.num=atoll(buf), .next=numlist};
		printf("%llu %p\n", numlist->num, numlist);

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
	printf("%i\n", cnode == cnode->next);
	while (cnode->next != NULL) {
		printf("%llu\n", cnode->num);
		cnode = cnode->next;

		//if ((cnode->num&byte) == (oxval&byte)) {
		//}
	}

	byte >>= 1;

	return 0;
}
