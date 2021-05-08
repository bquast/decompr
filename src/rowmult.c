#include <R.h>
#include <Rinternals.h>

SEXP rowmult(SEXP x, SEXP v) {
  SEXP dim = getAttrib(x, R_DimSymbol);
  if(isNull(dim)) error("x is not a matrix");
  if(TYPEOF(x) != REALSXP) error("x needs to be numeric (not integer)");
  if(TYPEOF(v) != REALSXP) error("v needs to be numeric (not integer)");
  int row = INTEGER(dim)[0], col = INTEGER(dim)[1];
  if(length(v) != col) error("ncol(x) needs to be equal to length(v)");
  SEXP out = PROTECT(allocVector(REALSXP, row * col));
  // Creating pointers
  double *px = REAL(x), *pv = REAL(v), *pout = REAL(out);
  for(int j = 0; j != col; ++j) {
    int s = j * row, e = s + row;
    double vj = pv[j];
    for(int i = s; i != e; ++i) pout[i] = px[i] * vj;
  }
  DUPLICATE_ATTRIB(out, x);
  UNPROTECT(1);
  return out;
}

static const R_CallMethodDef CallEntries[] = {
  {"C_rowmult", (DL_FUNC) &rowmult, 2},
  {NULL, NULL, 0}
};

void R_init_decompr(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}



