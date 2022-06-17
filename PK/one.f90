!
! Program to simulate one compartment model
! with oral absorption and first-order elimination
!

program one_com
  use advan2, only: one_compartment_oral
!  use stdlib_stats, only: mean 
  implicit none


  real, dimension(:), allocatable :: time, Y
  character(len=20) :: filename
  character(len=20) :: time_array
  ! define some integers
  integer :: i, ntime, n, j, iErr
  !real, external :: one_compartment_oral
  integer, parameter :: nparam = 3
  real :: DOSE
  real, dimension(nparam) :: p

  filename = "param.txt"
  open(1, file=filename, status="old")
  do i=1,nparam
    read(1, *) p(i)
  end do
  close(1)

  print * ,'------------ Parameters supplied ------------'
  print *, 'CL = ', p(1)
  print *, 'V  = ', p(2)
  print *, 'KA = ', p(3)

  !print *, "READING TIME ARRAY "

  time_array = "time.txt"
  ntime = 10

  allocate(time(ntime))
  allocate(Y(ntime))

  !iErr = 0
  open(2, file=time_array, status="old", iostat=iErr)
  if (iErr /= 0) then
    print *, "error opening file", trim(time_array)
    stop 1
  end if
  do j=1,ntime
    read(2, *) time(j)
  end do
  close(2)
  DOSE = 500
  open(3, file="data.out", status="new")
!  write (3, "(A12, 1x, A12)") "TIME", "CONC"
  do n=1,ntime
    Y(n) = one_compartment_oral(p(1), p(2), p(3), DOSE, time(n))
    write(3, "(es12.3,1x,es12.3)") time(n), Y(n)
  end do
  close(3) 
  print *, 'SIMULATION IS DONE: CHECK data.out'
!  print *, "Mean concentration = ", mean(Y) 

end program one_com
