#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#TEMPLATE (GWBTODOTemplate, 'GWB Alternative TODO Window'),FAMILY('ABC')
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#! MAINTENANCE
#! Created by Geoff Bomford 22/April/2026
#! www.comformark.com.au
#!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#PROCEDURE(GWBTODOProcedure,'GWB Alternative TODO procedure'),WINDOW  #! TODO Window
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!! <summary>
!!! Procedure not yet defined
!!! </summary>
%Procedure PROCEDURE !Procedure not yet defined - added by GWBTODO
#!
#!
#DISPLAY('The TODO Window will automatically close when the user clicks on the window.'),AT(10,,150,32)
#DISPLAY()
#DISPLAY('NOTE: The default window is MDI')
#DISPLAY('If you don''t start the procedure you MUST remove the MDI attribute')
#DISPLAY()
#DISPLAY('Message to Display:')
#PROMPT('Message to Display:',TEXT),%gwbMessage,DEFAULT('This procedure is currently in development')
#!
#!-----------------------------------------------------------------------------------
#! Declare a Global Variable, place it in the Global Data list so developers can access it
#LOCALDATA
GWBMessage  STRING(120)
GWBProcedureName  STRING(60)
#ENDLOCALDATA
#!-----------------------------------------------------------------------------------

#FOR(%LocalData)
%[20]LocalData %LocalDataStatement  #<!%LocalDataDescription
#ENDFOR
#AT(%DataSection),PRIORITY(5000),DESCRIPTION('Window Structure')
#SUSPEND
#MESSAGE('Standard Window Generation',3)
#EMBED(%DataSectionBeforeWindow,'Data Section, Before Window Declaration'),DATA,LEGACY
#!-----------------------------------------------------------------------------------
#! Add the window structure to the source procedure.
#! I start with a basic DEFAULT window, and allow the developer to edit the window,
#! but, make sure there are no menus, toolbars or buttons in the window.
#! Make sure the window is MDI - or won't be able to exit the app <g>
#!
#DECLARE(%GWBWindowAt)
#DECLARE(%GWBWindowStatement)
#DECLARE(%GWBIndentation)
#DECLARE(%GWBTimerPresent)
  #SET(%GWBWindowAt, EXTRACT(%WindowStatement,'AT'))
  #SET(%GWBWindowStatement,'WINDOW,' & %GWBWindowAt)
  #IF(EXTRACT(%WindowStatement,'FONT'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',' & EXTRACT(%WindowStatement,'FONT'))
  #ENDIF
  #IF(EXTRACT(%WindowStatement,'COLOR'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',' & EXTRACT(%WindowStatement,'COLOR'))
  #ENDIF
  #IF(EXTRACT(%WindowStatement,'WALLPAPER'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',' & EXTRACT(%WindowStatement,'WALLPAPER'))
  #ENDIF
  #IF(EXTRACT(%WindowStatement,'TILED'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',' & EXTRACT(%WindowStatement,'TILED'))
  #ENDIF
  #IF(EXTRACT(%WindowStatement,'CENTER'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',' & EXTRACT(%WindowStatement,'CENTER'))
  #ENDIF
  #IF(EXTRACT(%WindowStatement,'TIMER'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',' & EXTRACT(%WindowStatement,'TIMER'))
    #SET(%GWBTimerPresent,1)
  #ENDIF
  #IF(EXTRACT(%WindowStatement,'NOFRAME'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',' & EXTRACT(%WindowStatement,'NOFRAME'))
  #ENDIF
  #IF(EXTRACT(%WindowStatement,'MDI'))
    #SET(%GWBWindowStatement,%GWBWindowStatement & ',MDI')
  #ENDIF  
%[20]Window %GWBWindowStatement
  #SET(%GWBIndentation,0)
  #DECLARE(%GWBControlSourceLine)
  #FOR(%Control)
    #IF(%ControlIndent<%GWBIndentation)
      #LOOP
        #SET(%GWBIndentation,%GWBIndentation-1)
%[22+(2*%GWBIndentation)]Null END
        #IF(%ControlIndent=%GWBIndentation)
          #BREAK
        #ENDIF
      #ENDLOOP
    #ENDIF
    #SET(%GWBControlSourceLine,%ControlStatement)
    #CASE(%ControlType)
    #OF('MENU')
    #OROF('MENUBAR')
    #OROF('TOOLBAR')
    #OROF('ITEM')
    #! Do nothing
    #OF('OPTION')
    #OROF('GROUP')
    #OROF('SHEET')
    #OROF('TAB')
    #OROF('OLE')
%[22+(2*%GWBIndentation)]Null %GWBControlSourceLine
      #SET(%GWBIndentation,%GWBIndentation+1)
      #! Indent two spaces
    #ELSE
%[22+(2*%GWBIndentation)]Null %GWBControlSourceLine
    #ENDCASE
  #ENDFOR
  #LOOP,WHILE(%GWBIndentation)
    #SET(%GWBIndentation,%GWBIndentation-1)
%[22+(2*%GWBIndentation)]Null END
  #ENDLOOP
%[20]Null END
#EMBED(%DataSectionAfterWindow,'Data Section, After Window Declaration'),DATA,LEGACY
#?
#RESUME
#ENDAT
#!--------------------------------------
#EMBED(%DataSection,'Data Section'),DATA,TREE('Local Data{{PRIORITY(1000)}')          #! Embedded Source Code
  CODE
  gwbProcedureName = '%Procedure'
  #IF(%gwbMessage)
  gwbMessage = '%gwbMessage'
  #ELSE
  gwbMessage = 'This procedure has not been defined yet, please check back soon.'
  #ENDIF
#EMBED(%ProcessedCode,'Processed Code')     #! Embedded Source Code
#!-----------------------------------------------------------------------------------
#AT(%ProcessedCode),PRIORITY(4999)
#!--------------------------------------
  #EMBED(%BeforeOpenWindow,'Before Open Window')  #! Allow source code before opening the window
  OPEN(%Window)
  ?gwbMessagePrompt{Prop:Text} = gwbMessage
  #EMBED(%AfterOpenWindow,'After Open Window')  #! Allow source code after opening the window
  #EMBED(%WindowManagerMethodCodeSection,'WindowManager Method Executable Code Section')  #!Embed to allow other templates to post code
  #EMBED(%AfterDisableWindow,'After Disable Window')  #! Allow source code after Disabling the window
  ACCEPT
    CASE EVENT()
    #EMBED(%CaseEventTop,'CASE EVENT() Top')
    OF Event:Accepted
      CASE FIELD()
      OF ?OKButton
        POST(Event:CloseWindow)
      END    
    OF Event:AlertKey
      CASE KEYCODE()                                              #<! Splash window will close on mouse click
        OF MouseLeft
        OROF MouseLeft2
        OROF MouseRight
        POST(Event:CloseWindow)
      END  
    OF Event:CloseWindow
      BREAK
    #SUSPEND
    #IF(%GWBTimerPresent)
    OF Event:Timer
      #EMBED(%GWBTimerEvent,'Case Event Timer')
    #ENDIF
    #?
    #RESUME
    #EMBED(%CaseEventBottom,'CASE EVENT() Bottom')     #! Embedded Source Code
    END
  END
  SETKEYCODE(0)
  CLOSE(%Window)
#ENDAT
#!-----------------------------------------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),PRIORITY(8500)
TARGET{Prop:Alrt,255} = MouseLeft                               #<! Alert mouse clicks that will close window
TARGET{Prop:Alrt,254} = MouseLeft2
TARGET{Prop:Alrt,253} = MouseRight
#ENDAT
#!-----------------------------------------------------------------------------------
#AT(%PostWindowEventHandling,'LOSEFOCUS')
  POST(Event:CloseWindow)                                       #<! TODO window will close when focus is lost
#ENDAT
#!-----------------------------------------------------------------------------------
#!-----------------------------------------------------------------------------------
#EMBED(%ProcedureRoutines,'Procedure Routines'),DATA,LABEL
#EMBED(%LocalProcedures,'Local Procedures'),DATA,LABEL
#INSERT(%LocalMapCheck(ABC))
#!
#!---------------------------------------------------------
#DEFAULT
NAME GWBTODOWindow
CATEGORY 'GWB TODO'
[COMMON]
DESCRIPTION '%Procedure - GWB Alternative TODO Window'
FROM GWBTODOTemplate GWBTODOProcedure
[PROMPTS]
%WindowOperationMode DEFAULT  ('Use WINDOW setting')
%INISaveWindow LONG  (1)
[WINDOW]
window WINDOW,AT(,,241,144),CENTER,MDI,GRAY,FONT('Microsoft Sans Serif',8,, |
            FONT:regular),DOUBLE
        STRING(@s60),AT(14,9),USE(gwbProcedureName),CENTER,FONT(,12,,FONT:bold)
        PROMPT(''),AT(9,36,125,68),USE(?gwbMessagePrompt),FONT(,8,,FONT:bold),CENTER
        IMAGE('sv_small.jpg'),AT(151,49),USE(?LogoImage)
        BUTTON('OK'),AT(185,113),USE(?OKButton),FONT(,,,FONT:regular)
    END
#ENDDEFAULT
#!
#!
#!
#!
