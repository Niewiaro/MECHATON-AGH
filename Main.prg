' MECHATON AGH 2025
' Czterej pancerni i piec
'
' Pick and Place by juggling on Pallet
'
' This program picks parts from storage box, place them randomly on pallet and then juggles them between pallet positions
'
' Robot parameters
#define ROBOT_SPEED 50
#define ROBOT_ACCEL_X 50
#define ROBOT_ACCEL_Y 50
#define ROBOT_RANGE_Z -150
#define ROBOT_ARCH_ARCH_NUMBER 0
#define ROBOT_ARCH_DEPART_DIST 12
#define ROBOT_ARCH_APPRO_DIST 12
'
' Pallet parameters
#define PALLET_ROWS 3
#define PALLET_COLS 3
#define PALLET_HEIGHT 105
#define PALLET_OFFSET_X 10
#define PALLET_OFFSET_Y 10
#define PALLET_OFFSET_EDGE_X 5
#define PALLET_OFFSET_EDGE_Y 5

' Detail parameters
#define DETAIL_HEIGHT 10
#define DETAIL_EDGE 40

Global Preserve Boolean boolDetails(9)
Global Preserve Integer intPrevious

Function main
    ' --- Define variables ---
    ' counters
	

    ' cycle counter
	Long cycleCount
    cycleCount = 0

    ' --- Initialize robot ---
	InitRobot

    ' --- Main loop ---
	Do
		PickRandom
        PlaceRandom

        cycleCount = cycleCount + 1
        Print "Cycle count: ", cycleCount
	Loop
Fend

Function JumpWithDetails
    Integer i, j
    i = intPrevious / PALLET_COLS
    j = intPrevious % PALLET_COLS

    Jump pallet_0_0 +X(PALLET_OFFSET_EDGE_X + (PALLET_OFFSET_X * i) + (DETAIL_EDGE * i) + (DETAIL_EDGE * 0.5)) -Y(PALLET_OFFSET_EDGE_Y + (PALLET_OFFSET_Y * j) + (DETAIL_EDGE * j) + (DETAIL_EDGE * 0.5)) :Z(ROBOT_RANGE_Z + PALLET_HEIGHT + DETAIL_HEIGHT) C0
Fend

Function PickRandom
    Integer intRandom

    Do
		intRandom = Int(Rnd(9))
	Loop Until intRandom <> intPrevious && boolDetails(intRandom) = True

    intPrevious = intRandom
    boolDetails(intRandom) = False

    JumpWithDetails
Fend

Function PlaceRandom
    Integer intRandom

    Do
		intRandom = Int(Rnd(9))
	Loop Until intRandom <> intPrevious && boolDetails(intRandom) = False

    intPrevious = intRandom
    boolDetails(intRandom) = True

    JumpWithDetails
Fend

Function InitRobot
	Reset
	If Motor = Off Then
		Motor On
	EndIf
	Power High
	Speed ROBOT_SPEED
	Accel ROBOT_ACCEL_X, ROBOT_ACCEL_Y
    Arch ROBOT_ARCH_ARCH_NUMBER, ROBOT_ARCH_DEPART_DIST, ROBOT_ARCH_APPRO_DIST
Fend
