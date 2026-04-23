  MEMBER('ToDoWindow.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('ToDoWindow_BC0.CLW')
ToDoWindow_BC0:DctInit             PROCEDURE()
ToDoWindow_BC0:DctKill             PROCEDURE()
ToDoWindow_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  ToDoWindow_BC0:DctInit
  ToDoWindow_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  ToDoWindow_BC0:DctKill

