module advan2
  implicit none
  intrinsic :: exp

  public :: one_compartment_oral
  private

contains

  real function one_compartment_oral(cl, v, ka,d, t)
    !implicit none
    real, intent(in) :: cl, v, ka, t,d
    real :: k
    k = cl/v

    one_compartment_oral = d/v * ka/(ka - k) * (exp(-k *t - exp(-ka * t)))
  end function one_compartment_oral

end module advan2
