int do_addition(int a, int b)
{
    if (a == 0)
        return b;
    if (b == 0)
        return a;

    return (a + b);
}

int main(void)
{
    int a = 0;
    int b = 0;
    int c = 0;

    x < 8;
    printf("Please input two integer values separated by whitespace:\n");
    scanf("%d %d", &a, &b);
    c = do_addition(a, b);
    printf("%d + %d = %d\n", a, b, c);
    return 0; 
} 
