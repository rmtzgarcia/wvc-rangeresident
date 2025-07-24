! Script to simulate WVCs as a reaction diffusion process. Animal movement is modeled as a 2D isotropic Ornstein-Uhlenbeck process
! with uncorrelated movement components. The road is modeledes as a linear feature crossing the landscape North-South. The road 
! is characterized by a traffic intensity that translates into a probability of absorbing the animal trajectory in every animal crossing.

! The output of this script is the mean collision time as a function of the animal HR size, with the HR sampled in a logarithmic scale.

program det

implicit none

integer :: i,ij
integer, parameter :: Nreal = 1e4					! Number of realizations for each parameter combination
integer, parameter :: iseed = 134864561				! Seed for the random number generator

double precision :: x,y,t 							! Spatial coordinates of animal location and time
double precision :: dran_g							! Variable to store a Gaussian random number
double precision :: dran_u							! Variable to store a uniformly dist. random number
double precision :: loc								! Auxiliar variable to store whether the animal is on the left or right of the road
double precision :: mat 							! Mean collision time
double precision :: HR 								! HR size
double precision :: g 								! Diffusion intensity of the OU process
double precision :: p 								! Probability of collision upon crossing.
double precision :: tau 							! HR mean crossing time
double precision :: eta 							! Absorption rate (traffic intensity)
double precision :: dt 								! Time step discretization
double precision :: d 								! Road location in the x coordinate

double precision, parameter :: pi = 4.d0*datan(1.d0)! Definition of pi

!Strings to store variable values and output file names.
character(len=9) :: taustring
character(len=9) :: etastring
character(len=9) :: dtstring
character(len=9) :: dstring
character(len=150) :: filename

character *100 buffer

100	format(25F29.13) !output format

!HR crossing time, traffic intensity, time discretization, and road location are provided from the terminal.
call getarg(1,buffer)
read(buffer,*) tau
write(taustring,'(E9.3E2)') tau
call getarg(2,buffer)
read(buffer,*) eta
write(etastring,'(E9.3E2)') eta
call getarg(3,buffer)
read(buffer,*) dt
write(dtstring,'(E9.3E2)') dt
call getarg(4,buffer)
read(buffer,*) d
write(dstring,'(E9.3E2)') d

filename = "log-sampini-d="//dstring//"-eta="//etastring//"-dt="//dtstring//".dat"
open(unit=1, file=filename, status='unknown')

call dran_ini(iseed) !Call to the random number generator subroutine (dranxor.f90)

! Loop in home-range size
do ij=1,10

	HR = 10**((7.d0-dble(ij))/3.d0)  ! Definition of the HR so it is sampled in a logarithmic scale.

	mat = 0.d0						 ! Initialization of the mean collision time
	g = 2.d0*sqrt(HR)*5.d0			 ! Diffusion constant
	p = eta*dsqrt(pi*dt/(2.d0*g)) 	 ! Probability of collision upon death as derived in App. A.

	! Loop in the number of realizations for a given HR size
	do i = 1,Nreal

		!Initial condition
		t = 0.d0
		x = dran_g()*dsqrt(HR)
		y = dran_g()*dsqrt(HR)

1 		continue
		loc = sign(1.d0,x-d) 		! Check in which side of the road is the animal.
		x = x - dt*x*5.d0/dsqrt(HR) + dsqrt(g*dt)*dran_g() 		! Update the animal location integrating OU equations.
		y = y - dt*y*5.d0/dsqrt(HR) + dsqrt(g*dt)*dran_g()		! Update the animal location integrating OU equations.
		t = t + dt 					! Update time

		! If the animal has crossed the road, check if it's died. 
		if(loc.ne.sign(1.d0,x-d)) then
			if(dran_u().le.p) then
				mat = mat + t
				go to 2
			end if
		end if

		go to 1 		! If the animal has not died, continue updating its location.

2 	continue


	end do 				! End of loop in realizations.

write(1,*) HR,mat/dble(i)  ! Write the HR size and mean collision time in the output file

HR = HR + 1.d0 			   ! Update animal HR size.

end do

close(unit=1)

end program det