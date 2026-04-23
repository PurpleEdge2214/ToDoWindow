

   MEMBER('ToDoWindow.clw')                                ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('TODOWINDOW008.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Form Students
!!! </summary>
UpdateStudents PROCEDURE 

CurrentTab           STRING(80)                            ! 
ActionMessage        CSTRING(40)                           ! 
History::STU:Record  LIKE(STU:RECORD),THREAD
QuickWindow          WINDOW('Form Students'),AT(,,163,182),FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTER,GRAY,IMM,MDI,HLP('UpdateStudents'),SYSTEM
                       SHEET,AT(4,4,155,156),USE(?CurrentTab)
                         TAB('&1) General'),USE(?Tab:1)
                           PROMPT('&Number:'),AT(8,20),USE(?STU:Number:Prompt),TRN
                           ENTRY(@P###-##-####P),AT(61,20,52,10),USE(STU:Number),RIGHT(1),REQ
                           PROMPT('&First Name:'),AT(8,34),USE(?STU:FirstName:Prompt),TRN
                           ENTRY(@S20),AT(61,34,84,10),USE(STU:FirstName)
                           PROMPT('&Last Name:'),AT(8,48),USE(?STU:LastName:Prompt),TRN
                           ENTRY(@S20),AT(61,48,84,10),USE(STU:LastName)
                           PROMPT('&Address:'),AT(8,62),USE(?STU:Address:Prompt),TRN
                           ENTRY(@S20),AT(61,62,84,10),USE(STU:Address)
                           PROMPT('Address 2:'),AT(8,76),USE(?STU:Address2:Prompt),TRN
                           ENTRY(@s20),AT(61,76,84,10),USE(STU:Address2)
                           PROMPT('&City:'),AT(8,90),USE(?STU:City:Prompt),TRN
                           ENTRY(@S20),AT(61,90,84,10),USE(STU:City)
                           PROMPT('&State:'),AT(8,104),USE(?STU:State:Prompt),TRN
                           ENTRY(@S2),AT(61,104,40,10),USE(STU:State)
                           PROMPT('&Zip:'),AT(8,118),USE(?STU:Zip:Prompt),TRN
                           ENTRY(@n05),AT(61,118,40,10),USE(STU:Zip)
                           PROMPT('&Telephone:'),AT(8,132),USE(?STU:Telephone:Prompt),TRN
                           ENTRY(@s12),AT(61,132,52,10),USE(STU:Telephone)
                           PROMPT('Grad Year:'),AT(8,146),USE(?STU:GradYear:Prompt),TRN
                           ENTRY(@n4),AT(61,146,40,10),USE(STU:GradYear)
                         END
                       END
                       BUTTON('&OK'),AT(4,164,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancel'),AT(57,164,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                       BUTTON('&Help'),AT(110,164,49,14),USE(?Help),LEFT,ICON('WAHELP.ICO'),FLAT,MSG('See Help Window'), |
  STD(STD:Help),TIP('See Help Window')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
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

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Record Will Be Changed'
  OF DeleteRecord
    GlobalErrors.Throw(Msg:DeleteIllegal)
    RETURN
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateStudents')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?STU:Number:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(STU:Record,History::STU:Record)
  SELF.AddHistoryField(?STU:Number,1)
  SELF.AddHistoryField(?STU:FirstName,2)
  SELF.AddHistoryField(?STU:LastName,3)
  SELF.AddHistoryField(?STU:Address,4)
  SELF.AddHistoryField(?STU:Address2,5)
  SELF.AddHistoryField(?STU:City,6)
  SELF.AddHistoryField(?STU:State,7)
  SELF.AddHistoryField(?STU:Zip,8)
  SELF.AddHistoryField(?STU:Telephone,9)
  SELF.AddHistoryField(?STU:GradYear,11)
  SELF.AddUpdateFile(Access:Students)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Students.SetOpenRelated()
  Relate:Students.Open                                     ! File Students used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Students
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:None                        ! Deletes not allowed
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?STU:Number{PROP:ReadOnly} = True
    ?STU:FirstName{PROP:ReadOnly} = True
    ?STU:LastName{PROP:ReadOnly} = True
    ?STU:Address{PROP:ReadOnly} = True
    ?STU:Address2{PROP:ReadOnly} = True
    ?STU:City{PROP:ReadOnly} = True
    ?STU:State{PROP:ReadOnly} = True
    ?STU:Zip{PROP:ReadOnly} = True
    ?STU:Telephone{PROP:ReadOnly} = True
    ?STU:GradYear{PROP:ReadOnly} = True
  END
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('UpdateStudents',QuickWindow)               ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Students.Close
  END
  IF SELF.Opened
    INIMgr.Update('UpdateStudents',QuickWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
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
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Procedure not yet defined
!!! </summary>
ReportStarted_MDI PROCEDURE !Procedure not yet defined - added by GWBTODO

GWBMessage           STRING(120)                           !
GWBProcedureName     STRING(60)                            !
window               WINDOW,AT(,,241,144),FONT('Microsoft Sans Serif',8,,FONT:regular),CENTER,MDI
                       STRING(@s60),AT(14,9),USE(GWBProcedureName),FONT(,12,,FONT:bold),CENTER
                       PROMPT(''),AT(9,36,125,68),USE(?gwbMessagePrompt),FONT(,8,,FONT:bold),CENTER
                       IMAGE('sv_small.jpg'),AT(151,49),USE(?LogoImage)
                       BUTTON('OK'),AT(185,113),USE(?OKButton),FONT(,,,FONT:regular)
                     END

  CODE
  gwbProcedureName = 'ReportStarted_MDI'
  gwbMessage = 'This procedure is currently in development'
  OPEN(window)
  ?gwbMessagePrompt{Prop:Text} = gwbMessage
  TARGET{Prop:Alrt,255} = MouseLeft                        ! Alert mouse clicks that will close window
  TARGET{Prop:Alrt,254} = MouseLeft2
  TARGET{Prop:Alrt,253} = MouseRight
  ACCEPT
    CASE EVENT()
    OF Event:Accepted
      CASE FIELD()
      OF ?OKButton
        POST(Event:CloseWindow)
      END    
    OF Event:AlertKey
      CASE KEYCODE()                                       ! Splash window will close on mouse click
        OF MouseLeft
        OROF MouseLeft2
        OROF MouseRight
        POST(Event:CloseWindow)
      END  
    OF Event:CloseWindow
      BREAK
    END
  END
  SETKEYCODE(0)
  CLOSE(window)
!!! <summary>
!!! Procedure not yet defined
!!! </summary>
ReportNOStarted_SDI PROCEDURE !Procedure not yet defined - added by GWBTODO

GWBMessage           STRING(120)                           !
GWBProcedureName     STRING(60)                            !
window               WINDOW,AT(,,241,144),FONT('Microsoft Sans Serif',8,,FONT:regular),CENTER
                       STRING(@s60),AT(14,9),USE(GWBProcedureName),FONT(,12,,FONT:bold),CENTER
                       PROMPT(''),AT(9,36,125,68),USE(?gwbMessagePrompt),FONT(,8,,FONT:bold),CENTER
                       IMAGE('sv_small.jpg'),AT(151,49),USE(?LogoImage)
                       BUTTON('OK'),AT(185,113),USE(?OKButton),FONT(,,,FONT:regular)
                     END

  CODE
  gwbProcedureName = 'ReportNOStarted_SDI'
  gwbMessage = 'This procedure is currently in development'
  OPEN(window)
  ?gwbMessagePrompt{Prop:Text} = gwbMessage
  TARGET{Prop:Alrt,255} = MouseLeft                        ! Alert mouse clicks that will close window
  TARGET{Prop:Alrt,254} = MouseLeft2
  TARGET{Prop:Alrt,253} = MouseRight
  ACCEPT
    CASE EVENT()
    OF Event:Accepted
      CASE FIELD()
      OF ?OKButton
        POST(Event:CloseWindow)
      END    
    OF Event:AlertKey
      CASE KEYCODE()                                       ! Splash window will close on mouse click
        OF MouseLeft
        OROF MouseLeft2
        OROF MouseRight
        POST(Event:CloseWindow)
      END  
    OF Event:CloseWindow
      BREAK
    END
  END
  SETKEYCODE(0)
  CLOSE(window)
