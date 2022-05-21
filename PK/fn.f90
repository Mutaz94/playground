! 
! fn.90
!

function sqr(x) result(y)
    implicit none 
    intrinsic :: sqrt 

    real :: x, y

    y = x ** 2

    end function sqr 
