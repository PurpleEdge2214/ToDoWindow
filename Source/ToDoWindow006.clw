

   MEMBER('ToDoWindow.clw')                                ! This is a MEMBER module

                     MAP
                       INCLUDE('TODOWINDOW006.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Procedure not yet defined
!!! </summary>
ReportStudentsBySTU:KeyGradYear PROCEDURE !Procedure not yet defined
  CODE
  GlobalErrors.ThrowMessage(Msg:ProcedureToDo,'ReportStudentsBySTU:KeyGradYear') ! This procedure acts as a place holder for a procedure yet to be defined
  SETKEYCODE(0)
  GlobalResponse = RequestCancelled                        ! Request cancelled is the implied action
