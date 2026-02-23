*allowShellResize:              true
XConsole.translations:          #override\
        <MapNotify>:            Deiconified()   \n\
        <UnmapNotify>:          Iconified()     \n\
        <Message>WM_PROTOCOLS:  Quit()
XConsole.baseTranslations:              #override\
        <MapNotify>:            Deiconified()   \n\
        <UnmapNotify>:          Iconified()     \n\
        <Message>WM_PROTOCOLS:  Quit()
*text.translations:             #override\
        <Btn4Down>:             scroll-one-line-down() \n\
        <Btn5Down>:             scroll-one-line-up() \n\
        Ctrl<KeyPress>C:        Clear() \n\
        <KeyPress>Clear:        Clear()
*text.baseTranslations:         #override\
        <Btn4Down>:             scroll-one-line-down() \n\
        <Btn5Down>:             scroll-one-line-up() \n\
        Ctrl<KeyPress>C:        Clear() \n\
        <KeyPress>Clear:        Clear()
*text.scrollVertical:           Never
*text.scrollHorizontal:         Never
*text.width:                    #WIDTH#
*text.height:                   #HEIGHT#
*text.allowResize:              true
*editType:                      read
