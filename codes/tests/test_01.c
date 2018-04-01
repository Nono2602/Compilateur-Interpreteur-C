int fact(int a) {
	int r = 0;
	if (a < 2) {
		r = 1;
	} else {
		int c = fact(a - 1);
		r = a * c;
	}
	return r;
}

int main() {
	int a = 5;
	int b;
	b = fact(a);
	printf(b);
	return b;
}
