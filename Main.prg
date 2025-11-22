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


Function main
    ' --- Define variables ---
    ' counters
	Integer i, j
    i = 0
    j = 0

    ' cycle counter
	Long cycleCount
    cycleCount = 0

    ' --- Initialize robot ---
	InitRobot

    ' --- Main loop ---
	Do
		For i = 0 To PALLET_ROWS - 1
            For j = 0 To PALLET_COLS - 1
                Jump pallet_0_0 +X(PALLET_OFFSET_EDGE_X + (PALLET_OFFSET_X * i) + (DETAIL_EDGE * i) + (DETAIL_EDGE * 0.5)) -Y(PALLET_OFFSET_EDGE_Y + (PALLET_OFFSET_Y * j) + (DETAIL_EDGE * j) + (DETAIL_EDGE * 0.5)) +Z(ROBOT_RANGE_Z + PALLET_HEIGHT + DETAIL_HEIGHT) C0
                Wait .1
                cycleCount = cycleCount + 1
                Print "Cycle count: ", cycleCount
            Next j
		Next i
	Loop

Fend

Function InitRobot
	Reset
	If Motor = Off Then
		Motor On
	EndIf
	Power High
	Speed ROBOT_SPEED
	Accel ROBOT_ACCEL_X, ROBOT_ACCEL_Y
    Arch 0, 12, 12
Fend
