// Demo.cpp : Defines the entry point for the application.
//

#include "Demo.h"

void test_blaze();
void test_eigen();
void test_gmp();
void test_mpfr();

int main()
{
	test_blaze();
	test_eigen();
	test_gmp();
	test_mpfr();
	
	return 0;
}

// https://bitbucket.org/blaze-lib/blaze/wiki/Getting%20Started
void test_blaze()
{
	const size_t N(100UL);
	const size_t iterations(10UL);

	const size_t NN(N * N);

	blaze::CompressedMatrix<double, blaze::rowMajor> A(NN, NN);
	blaze::DynamicVector<double, blaze::columnVector> x(NN, 1.0), b(NN, 0.0), r(NN), p(NN), Ap(NN);
	double alpha, beta, delta;

	A(1, 1) = 2.0;

	// Performing the CG algorithm
	r = b - A * x;
	p = r;
	delta = (r, r);

	for (size_t iteration = 0UL; iteration < iterations; ++iteration)
	{
		Ap = A * p;
		alpha = delta / (p, Ap);
		x += alpha * p;
		r -= alpha * Ap;
		beta = (r, r);
		if (std::sqrt(beta) < 1E-8) break;
		p = r + (beta / delta) * p;
		delta = beta;
	}

	std::cout << "beta = " << beta << std::endl;
}

// https://eigen.tuxfamily.org/dox/GettingStarted.html
void test_eigen()
{
	Eigen::MatrixXd A(2, 2);
	A << 1, 2, 3, 4;
	Eigen::VectorXd b(2);
	b << 5, 6;
	Eigen::VectorXd x = A.colPivHouseholderQr().solve(b);
	std::cout << x << std::endl;
}

// https://github.com/alisw/GMP/blob/master/demos/isprime.c
void test_gmp()
{
	mpz_t n;
	mpz_init(n);
	mpz_set_str(n, "123456789", 0);
	auto is_prime = mpz_probab_prime_p (n, 25);
	std::cout << is_prime << std::endl;
}

// https://github.com/alisw/MPFR/blob/master/examples/sample.c
void test_mpfr()
{
	unsigned int i;
	mpfr_t s, t, u;

	mpfr_init2(t, 200);
	mpfr_set_d(t, 1.0, MPFR_RNDD);
	mpfr_init2(s, 200);
	mpfr_set_d(s, 1.0, MPFR_RNDD);
	mpfr_init2(u, 200);
	for (i = 1; i <= 100; i++)
	{
		mpfr_mul_ui(t, t, i, MPFR_RNDU);
		mpfr_set_d(u, 1.0, MPFR_RNDD);
		mpfr_div(u, u, t, MPFR_RNDD);
		mpfr_add(s, s, u, MPFR_RNDD);
	}
	printf("Sum is ");
	mpfr_out_str(stdout, 10, 0, s, MPFR_RNDD);
	putchar('\n');
	mpfr_clear(s);
	mpfr_clear(t);
	mpfr_clear(u);
}