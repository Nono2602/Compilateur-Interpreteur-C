int fun(int a, int b) {
	int c = a+b;
	return (c+c)+c;
}

int main() {
	int a = 2;
	int b = 4;
	return fun(a, b);
}
