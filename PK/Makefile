FC=nagfor
FFLAGS=-O3 
#-I/opt/miniconda3/include/fortran_stdlib/GNU-9.3.0/
SRC=advan.f90 one.f90

OBJ=$(SRC:.f90=.o)

%.o: %.f90
	$(FC) $(FFLAGS) -o $@ -c $<

one_pk: $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ)

clean:
	@rm *.o *.mod one_pk *.ou
