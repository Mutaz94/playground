FC=ifort
FFLAGS=-O3
SRC=advan.f90 one.f90

OBJ=$(SRC:.f90=.o)

%.o: %.f90
	$(FC) $(FFLAGS) -o $@ -c $<

one_pk: $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ)

clean:
	@rm *.o *.mod one_pk *.out
