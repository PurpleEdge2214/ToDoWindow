# gwbTODOWindow

## A template for Clarion for Windows

### Instructions

#### The Template
1. Copy the gwbToDoWindow.tpl to your Clarion accessories\template\win\ folder
2. Register the template in Clarion
3. Optionally edit the template window
    The template has a default window which can be edited using Ctrl-D over the window definition line.
    This will open the window designer in Clarion
    The default window has...
    a title string using the gwbProcedureName variable which is automatically set to the procedure name
    a prompt control which receives the default message displayed to the user
    an image control that could contain your business logo
    an OK button to close the window with the enter key
4. Optionally edit the default message to be displayed on the window - gebMessage string variable

#### Using the Template
1. The template is intended as a replacement for the standard Clarion TODO message, which can't be configure
2. A TODO procedure is created when a procedure is named in a call, but that procedure has not yet been defined
3. The idea with this template is that the procedure call remains unchanged, but this template is used to replace the Clarion TODO procedure
4. To do that, simply click on the TODO procedure, as if defining the procedure, and choose the gwbTODO template
5. IT IS IMPORTANT that you choose the gwbTODO template from the "Default" tab, otherwise it won't work!
6. IT IS IMPORTANT to know whether the procedure is STARTed or NOT. If NOT started, remove the MDI attribute from the gwbTODO window.
7. The template will open and you will be able to edit the window for each procedure where you use it, if you wish.
8. Under the "Actions" tab for the procedure you can override the default message for this procedure, if you wish.
