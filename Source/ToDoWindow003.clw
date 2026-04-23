

   MEMBER('ToDoWindow.clw')                                ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('TODOWINDOW003.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('TODOWINDOW007.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('TODOWINDOW008.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the Students file
!!! </summary>
BrowseStudents PROCEDURE 

CurrentTab           STRING(80)                            ! 
BRW1::View:Browse    VIEW(Students)
                       PROJECT(STU:Number)
                       PROJECT(STU:FirstName)
                       PROJECT(STU:LastName)
                       PROJECT(STU:Address)
                       PROJECT(STU:Address2)
                       PROJECT(STU:City)
                       PROJECT(STU:State)
                       PROJECT(STU:Zip)
                       PROJECT(STU:Telephone)
                       PROJECT(STU:GradYear)
                       PROJECT(STU:Major)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
STU:Number             LIKE(STU:Number)               !List box control field - type derived from field
STU:FirstName          LIKE(STU:FirstName)            !List box control field - type derived from field
STU:LastName           LIKE(STU:LastName)             !List box control field - type derived from field
STU:Address            LIKE(STU:Address)              !List box control field - type derived from field
STU:Address2           LIKE(STU:Address2)             !List box control field - type derived from field
STU:City               LIKE(STU:City)                 !List box control field - type derived from field
STU:State              LIKE(STU:State)                !List box control field - type derived from field
STU:Zip                LIKE(STU:Zip)                  !List box control field - type derived from field
STU:Telephone          LIKE(STU:Telephone)            !List box control field - type derived from field
STU:GradYear           LIKE(STU:GradYear)             !Browse key field - type derived from field
STU:Major              LIKE(STU:Major)                !Browse key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Browse the Students file'),AT(,,358,198),FONT('Microsoft Sans Serif',8,,FONT:regular, |
  CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MDI,HLP('BrowseStudents'),SYSTEM
                       LIST,AT(8,30,342,124),USE(?Browse:1),HVSCROLL,FORMAT('52L(2)|M~Number~L(2)@P###-##-####' & |
  'P@80L(2)|M~First Name~L(2)@S20@80L(2)|M~Last Name~L(2)@S20@80L(2)|M~Address~L(2)@S20' & |
  '@80L(2)|M~Address 2~L(2)@s20@80L(2)|M~City~L(2)@S20@24L(2)|M~State~L(2)@S2@24R(2)|M~' & |
  'Zip~C(0)@n05@52L(2)|M~Telephone~L(2)@s12@'),FROM(Queue:Browse:1),IMM,MSG('Browsing t' & |
  'he Students file')
                       BUTTON('&View'),AT(142,158,49,14),USE(?View:2),LEFT,ICON('WAVIEW.ICO'),FLAT,MSG('View Record'), |
  TIP('View Record')
                       BUTTON('&Insert'),AT(195,158,49,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),FLAT,MSG('Insert a Record'), |
  TIP('Insert a Record')
                       BUTTON('&Change'),AT(248,158,49,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'),DEFAULT,FLAT, |
  MSG('Change the Record'),TIP('Change the Record')
                       BUTTON('&Delete'),AT(301,158,49,14),USE(?Delete:3),LEFT,ICON('WADELETE.ICO'),FLAT,MSG('Delete the Record'), |
  TIP('Delete the Record')
                       SHEET,AT(4,4,350,172),USE(?CurrentTab)
                         TAB('&1) by Major'),USE(?Tab:2)
                           BUTTON('Select Majors'),AT(8,158,118,14),USE(?SelectMajors),LEFT,ICON('WAPARENT.ICO'),FLAT, |
  MSG('Select Parent Field'),TIP('Select Parent Field')
                         END
                         TAB('&2) by Last Name'),USE(?Tab:3)
                         END
                         TAB('&3) by Grad Year'),USE(?Tab:4)
                         END
                       END
                       BUTTON('&Close'),AT(252,180,49,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                       BUTTON('&Help'),AT(305,180,49,14),USE(?Help),LEFT,ICON('WAHELP.ICO'),FLAT,MSG('See Help Window'), |
  STD(STD:Help),TIP('See Help Window')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort1:Locator  StepLocatorClass                      ! Conditional Locator - CHOICE(?CurrentTab) = 2
BRW1::Sort2:Locator  StepLocatorClass                      ! Conditional Locator - CHOICE(?CurrentTab) = 3
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('BrowseStudents')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Majors.SetOpenRelated()
  Relate:Majors.Open                                       ! File Majors used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Students,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1.RetainRow = 0
  BRW1.AddSortOrder(,STU:KeyLastName)                      ! Add the sort order for STU:KeyLastName for sort order 1
  BRW1.AddLocator(BRW1::Sort1:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort1:Locator.Init(,STU:LastName,1,BRW1)           ! Initialize the browse locator using  using key: STU:KeyLastName , STU:LastName
  BRW1.AddSortOrder(,STU:KeyGradYear)                      ! Add the sort order for STU:KeyGradYear for sort order 2
  BRW1.AddLocator(BRW1::Sort2:Locator)                     ! Browse has a locator for sort order 2
  BRW1::Sort2:Locator.Init(,STU:GradYear,1,BRW1)           ! Initialize the browse locator using  using key: STU:KeyGradYear , STU:GradYear
  BRW1.AddSortOrder(,STU:MajorKey)                         ! Add the sort order for STU:MajorKey for sort order 3
  BRW1.AddRange(STU:Major,Relate:Students,Relate:Majors)   ! Add file relationship range limit for sort order 3
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 3
  BRW1::Sort0:Locator.Init(,STU:LastName,1,BRW1)           ! Initialize the browse locator using  using key: STU:MajorKey , STU:LastName
  BRW1.AddField(STU:Number,BRW1.Q.STU:Number)              ! Field STU:Number is a hot field or requires assignment from browse
  BRW1.AddField(STU:FirstName,BRW1.Q.STU:FirstName)        ! Field STU:FirstName is a hot field or requires assignment from browse
  BRW1.AddField(STU:LastName,BRW1.Q.STU:LastName)          ! Field STU:LastName is a hot field or requires assignment from browse
  BRW1.AddField(STU:Address,BRW1.Q.STU:Address)            ! Field STU:Address is a hot field or requires assignment from browse
  BRW1.AddField(STU:Address2,BRW1.Q.STU:Address2)          ! Field STU:Address2 is a hot field or requires assignment from browse
  BRW1.AddField(STU:City,BRW1.Q.STU:City)                  ! Field STU:City is a hot field or requires assignment from browse
  BRW1.AddField(STU:State,BRW1.Q.STU:State)                ! Field STU:State is a hot field or requires assignment from browse
  BRW1.AddField(STU:Zip,BRW1.Q.STU:Zip)                    ! Field STU:Zip is a hot field or requires assignment from browse
  BRW1.AddField(STU:Telephone,BRW1.Q.STU:Telephone)        ! Field STU:Telephone is a hot field or requires assignment from browse
  BRW1.AddField(STU:GradYear,BRW1.Q.STU:GradYear)          ! Field STU:GradYear is a hot field or requires assignment from browse
  BRW1.AddField(STU:Major,BRW1.Q.STU:Major)                ! Field STU:Major is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('BrowseStudents',QuickWindow)               ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: UpdateStudents
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Majors.Close
  END
  IF SELF.Opened
    INIMgr.Update('BrowseStudents',QuickWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    UpdateStudents
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?SelectMajors
      ThisWindow.Update()
      GlobalRequest = SelectRecord
      SelectMajors()
      ThisWindow.Reset
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END
  SELF.ViewControl = ?View:2                               ! Setup the control used to initiate view only mode


BRW1.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF CHOICE(?CurrentTab) = 2
    RETURN SELF.SetSort(1,Force)
  ELSIF CHOICE(?CurrentTab) = 3
    RETURN SELF.SetSort(2,Force)
  ELSE
    RETURN SELF.SetSort(3,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

