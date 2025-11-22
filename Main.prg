' MECHATON AGH 2025
' Czterej pancerni i piec
'
' Pick and Place by juggling on Pallet
'
' This program picks parts from storage box, 
` place them randomly on pallet and then juggles them between pallet positions
'
' Debug
#define DEBUG True
' Robot parameters
#define ROBOT_SPEED 50
#define ROBOT_ACCEL_X 50
#define ROBOT_ACCEL_Y 50
#define ROBOT_RANGE_Z -170
#define ROBOT_ARCH_ARCH_NUMBER 0
#define ROBOT_ARCH_DEPART_DIST 12
#define ROBOT_ARCH_APPRO_DIST 12
#define ROBOT_WAIT_TIME 0.1
#define ROBOT_GRIPPER_OFFSET_X -50
#define ROBOT_GRIPPER_OFFSET_Y 0
#define ROBOT_GRIPPER_OFFSET_Z 85

' Pallet parameters
#define PALLET_ROWS 3
#define PALLET_COLS 3
#define PALLET_HEIGHT 5
#define PALLET_OFFSET_X 10
#define PALLET_OFFSET_Y 10
#define PALLET_OFFSET_EDGE_X 5
#define PALLET_OFFSET_EDGE_Y 5

' Detail parameters
#define DETAIL_HEIGHT 10
#define DETAIL_EDGE 40
#define DETAIL_AMOUNT 4
#define DETAIL_BOX_OFFSET_X 5
#define DETAIL_BOX_OFFSET_Y 5
#define DETAIL_BOX_OFFSET_Z 5

Global Preserve Boolean boolDetails(9) ' PALLET_ROWS * PALLET_COLS
Global Preserve Integer intPrevious

Function main
    Print "Start Main"

    ' --- Define variables ---
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

    Print "End Main"
Fend

Function JumpWithDetails
    Integer i, j
    i = intPrevious / PALLET_COLS
    j = intPrevious Mod PALLET_COLS

    Jump pallet_0_0 +X(PALLET_OFFSET_EDGE_X + (PALLET_OFFSET_X * i) + (DETAIL_EDGE * i) + (DETAIL_EDGE * 0.5) - ROBOT_GRIPPER_OFFSET_X) -Y(PALLET_OFFSET_EDGE_Y + (PALLET_OFFSET_Y * j) + (DETAIL_EDGE * j) + (DETAIL_EDGE * 0.5) - ROBOT_GRIPPER_OFFSET_Y) :Z(ROBOT_RANGE_Z + PALLET_HEIGHT + DETAIL_HEIGHT + ROBOT_GRIPPER_OFFSET_Z) C0
Fend

Function PickRandom
    Print "Start PickRandom"

    Integer intRandom

    Do
		intRandom = Int(Rnd(9))
        If DEBUG Then
            Print "intRandom", intRandom
            Print "intPrevious", intPrevious
            Print "boolDetails(intRandom)", boolDetails(intRandom)
        EndIf
	Loop Until intRandom <> intPrevious And boolDetails(intRandom) = True

    intPrevious = intRandom
    boolDetails(intRandom) = False

    JumpWithDetails
    Wait ROBOT_WAIT_TIME
    On Gripper
    Wait ROBOT_WAIT_TIME

    Print "End PickRandom"
Fend

Function PlaceRandom
    Print "Start PlaceRandom"

    Integer intRandom

    Do
		intRandom = Int(Rnd(9))
        If DEBUG Then
            Print "intRandom", intRandom
            Print "intPrevious", intPrevious
            Print "boolDetails(intRandom)", boolDetails(intRandom)
        EndIf
	Loop Until intRandom <> intPrevious And boolDetails(intRandom) = False

    intPrevious = intRandom
    boolDetails(intRandom) = True

    JumpWithDetails
    Wait ROBOT_WAIT_TIME
    Off Gripper
    Wait ROBOT_WAIT_TIME

    Print "End PlaceRandom"
Fend

Function InitRobot
    Print "Start InitRobot"

    ' If (DETAIL_AMOUNT * DETAIL_HEIGHT) > (-ROBOT_RANGE_Z) Then
    '     Print "Error: Too many details or too high details!"
    '     Quit All
    ' EndIf

	Reset
	If Motor = Off Then
		Motor On
	EndIf
	Power High
	Speed ROBOT_SPEED
	Accel ROBOT_ACCEL_X, ROBOT_ACCEL_Y
    Arch ROBOT_ARCH_ARCH_NUMBER, ROBOT_ARCH_DEPART_DIST, ROBOT_ARCH_APPRO_DIST

    Print "Jumping home position"
    Jump home1 C0
    Print "Jumped home position"

    Integer i
    i = 0

    intPrevious = -1

    For i = 0 To (PALLET_ROWS * PALLET_COLS) - 1
        boolDetails(i) = False
    Next i

    For i = 0 To DETAIL_AMOUNT - 1
        Jump box_0_0 +X(DETAIL_BOX_OFFSET_X + (DETAIL_EDGE * 0.5) - ROBOT_GRIPPER_OFFSET_X) -Y(DETAIL_BOX_OFFSET_Y + (DETAIL_EDGE * 0.5) - ROBOT_GRIPPER_OFFSET_Y) :Z(ROBOT_RANGE_Z + DETAIL_BOX_OFFSET_Z + (DETAIL_HEIGHT * (DETAIL_AMOUNT - i)) + ROBOT_GRIPPER_OFFSET_Z) C0
        
        PlaceRandom
    Next i

    Print "End InitRobot"
Fend
