
; for os specific recipies
(define os (system-type 'os))

; defining the arg separator provides the boundary
; after which starlight will ignore the rest of
; the contents of the input field for the purposes
; of matching a target
(define arg-separator #rx"[ :]")

; function to get the contents after the colon
(define (get-after-colon theinput)
  (let ([separated (string-split theinput ":")])
    (string-trim (car (cdr separated)))))

(define (mexec astring)
  (let [(thestring (string-append "open /Applications/" astring ".app"))]
    (exec thestring)))

(define SEARCH-PREFIX "")
(if (eq? os 'macosx) (set! SEARCH-PREFIX "open -a Firefox ") '())
(if (eq? os 'unix) (set! SEARCH-PREFIX "firefox --new-tab ") '())


(define lookup
  `((reload (load-rc))
    (repl (graphical-read-eval-print-loop))
    (about (send about-dialog show #t))
    (kill (begin (stop-server) (exit 0)))
    (google (let [(url (string-append SEARCH-PREFIX "'http://google.com/search?q=" (get-after-colon inputcontents) "'"))] (exec url)))
    (wiki (let [(url (string-append SEARCH-PREFIX "'http://en.wikipedia.org/wiki/Special:Search?search=" (get-after-colon inputcontents) "'"))] (exec url)))
    (youtube (let [(url (string-append SEARCH-PREFIX "'http://www.youtube.com/results?search_query=" (get-after-colon inputcontents) "'"))] (exec url)))
    (define (let [(url (string-append SEARCH-PREFIX "'http://www.dictionary.com/browse/" (get-after-colon inputcontents) "?s=t'"))] (exec url)))
    (syn (let [(url (string-append SEARCH-PREFIX "'http://www.thesaurus.com/browse/" (get-after-colon inputcontents) "?s=t'"))] (exec url)))
    (oclc (let [(url (string-append SEARCH-PREFIX "'http://classify.oclc.org/classify2/ClassifyDemo?search-title-txt=" (get-after-colon inputcontents) "&startRec=0'"))] (exec url)))
    (phone (let [(url (string-append SEARCH-PREFIX "'http://phone.apps.nypl.org/home/set_form_vars?basicsearch=" (get-after-colon inputcontents) "'"))] (exec url)))
    (worldcat (let [(url (string-append SEARCH-PREFIX "'https://www.worldcat.org/search?qt=worldcat_org_bks&q=" (get-after-colon inputcontents) "'"))] (exec url)))
    (esen (let [(url (string-append SEARCH-PREFIX "'https://translate.google.com/#es/en/" (get-after-colon inputcontents) "'"))] (exec url)))
    (enes (let [(url (string-append SEARCH-PREFIX "'https://translate.google.com/#en/es/" (get-after-colon inputcontents)  "'"))] (exec url)))))

(define mac-lookup
  `((firefox (mexec "Firefox"))
    (terminal (mexec "iTerm"))
    (macvim (mexec "MacVim"))
    (calendar (mexec "Calendar"))
    (contacts (mexec "Contacts"))
    (whatsapp (mexec "WhatsApp"))
    (itunes (mexec "iTunes"))
    (spotify (mexec "Spotify"))
    (image-capture (mexec "Image\\ Capture"))
    (app-store (mexec "App\\ Store"))
    (todo (mexec "2Do"))
    (toodledo (exec "open 'http://toodledo.com'"))
    (monitor (mexec "Utilities/Activity\\ Monitor"))
    (gmail (exec "open 'http://gmail.com'"))
    (preview (mexec "Preview"))
    (slack (mexec "Slack"))
    (messages (mexec "Messages"))
    (chrome (mexec "Google\\ Chrome"))
    (garageband (mexec "GarageBand"))
    (rstudio (mexec "RStudio"))
    (config (exec "open ~/.starlight/config.rkt"))
    (preferences (mexec "System\\ Preferences"))
    (dictionary (mexec "Dictionary"))
    (notes (exec "open ~/Dropbox/Unclutter\\ Notes/notas.txt"))
    (lock (exec "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"))
    (shutdown (exec "osascript -e 'tell app \"loginwindow\" to «event aevtrsdn»'"))
    (sshutdown (exec "osascript -e 'tell app \"System Events\" to shut down'"))
    (sreboot (exec "osascript -e 'tell app \"loginwindow\" to «event aevtrrst»'"))
    (reboot (exec "osascript -e 'tell app \"System Events\" to restart'"))
    (open (let [(cmd (string-append "open /Applications/" (get-after-colon inputcontents) ".app"))] (exec cmd)))))

(define unix-lookup
  '((firefox (exec "firefox &"))
    (lock (exec "xscreensaver-command -lock"))
    (notes (exec "xfce4-terminal -x vim /home/tony/Dropbox/Unclutter\\ Notes/arch-notes.txt &"))
    (gmail (exec "firefox --new-tab 'http://gmail.com'"))
    (todo (exec "firefox --new-tab 'http://toodledo.com'"))
    (chrome (exec "google-chrome-stable &"))
    (terminal (exec "xfce4-terminal &"))
    (chrome (exec "google-chrome-stable &"))
    (incognito (exec "google-chrome-stable --incognito &"))
    (explorer (exec "pcmanfm &"))
    (clock (exec "xclock -d -sharp -render -chime"))
    (watch (exec "xclock -sharp -render -chime"))
    (volume (exec "xfce4-terminal -x alsamixer"))
    (night (exec "redshift -O 2500"))
    (deepnight (exec "redshift -O 2000"))
    (day (exec "redshift -O 5500"))
    (time (exec "flash-time"))
    (spotify (exec "spotify &"))
    (whatsapp (exec "Whatsapp &"))
    (gnumeric (exec "gnumeric &"))
    (libreoffice (exec "libreoffice &"))
    (mendeley (exec "mendeleydesktop &"))
    (shutdown (exec "xfce4-terminal -x sudo shutdown -h now"))
    (reboot (exec "xfce4-terminal -x sudo shutdown -r now"))))


(if (eq? os 'macosx) (set! lookup (append lookup mac-lookup)) '())
(if (eq? os 'unix) (set! lookup (append lookup unix-lookup)) '())

