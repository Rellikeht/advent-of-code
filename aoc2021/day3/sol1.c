#include <stdio.h>

typedef unsigned long long btype;

int main() {
	char buf[sizeof(btype)*8] = {0};
	btype endval = 0;
	int amounts[sizeof(btype)*8] = {0};
	int i = 0, lines = 0;

	while (!feof(stdin)) {
		scanf("%s", buf);
		while (buf[i] != 0) {
			amounts[i] += buf[i]-'0';
			i++;
		}

		lines++;
		i = 0;
	}

	lines >>= 1;
	while (buf[i] != 0) {
		endval <<= 1;
		if (amounts[i] > lines)
			endval += 1;
		i++;
	}

	//const btype ev2 = (~endval)<<(sizeof(btype)-i)>>(sizeof(btype)-i);
	const btype ev2 = (1<<i) - endval-1;
	printf("%llu %llu %llu\n", endval, ev2, endval*ev2);

	return 0;
}
