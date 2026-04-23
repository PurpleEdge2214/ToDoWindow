

   MEMBER('ToDoWindow.clw')                                ! This is a MEMBER module

                     MAP
                       INCLUDE('TODOWINDOW005.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Procedure not yet defined
!!! </summary>
ReportStudentsBySTU:KeyLastName PROCEDURE !Procedure not yet defined - added by GWBTODO

GWBMessage           STRING(120)                           !
GWBProcedureName     STRING(60)                            !
window               WINDOW,AT(,,241,144),FONT('Microsoft Sans Serif',8,,FONT:regular),CENTER,MDI
                       PROMPT(''),AT(9,36,125,68),USE(?gwbMessagePrompt),FONT(,8,,FONT:bold),CENTER
                       IMAGE('sv_small.jpg'),AT(151,49),USE(?LogoImage)
                       BUTTON('OK'),AT(185,113),USE(?OKButton),FONT(,,,FONT:regular)
                       STRING(@s60),AT(14,9),USE(?gwbProcedureName),FONT(,12,,FONT:bold),CENTER
                     END

  CODE
  gwbProcedureName = 'ReportStudentsBySTU:KeyLastName'
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
