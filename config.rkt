
; for os specific recipies
(define os (system-type 'os))

; defining the arg separator provides the boundary
; after which starlight will ignore the rest of
; the contents of the input field for the purposes
; of matching a target
(define arg-separator #rx":")

; (define matching? string-contains?)

; function to get the contents after the colon
(define (get-after-colon theinput)
  (let ([separated (string-split theinput ":")])
    (string-trim (car (cdr separated)))))

(define (mexec astring)
  (let [(thestring (string-append "open /Applications/" astring ".app"))]
    (exec thestring)))

(define (dexec astring)
  (let [(thestring (string-append "/home/tony/.zsh/more-scripts/open " astring))]
    (exec thestring)))

(define (sexec astring)
  (let [(thestring (string-append "systemd-run --scope --user " astring))]
    (exec thestring)))

(define SEARCH-PREFIX "")
(if (eq? os 'macosx) (set! SEARCH-PREFIX "open -a Firefox ") '())
(if (eq? os 'unix) (set! SEARCH-PREFIX "systemd-run --scope --user firefox --new-tab ") '())


(define (disp-output amessage)
  (define tmp (new text-field% [parent cmdout-dialog] [label #f] [enabled #f]
                   [min-width 600] [min-height 600] [style '(multiple)]))
  (define tmpq (new button% [parent cmdout-dialog] [label "Ok"]
                    [callback
                      (lambda (a b)
                        (send cmdout-dialog show #f))]))
  (send tmp set-value amessage)
  (send cmdout-dialog center)
  (send cmdout-dialog show #t)
  (send tmpq focus)
  (send cmdout-dialog delete-child tmp)
  (send cmdout-dialog delete-child tmpq))



;; remember that if the cadr (when called with `eval` returns #f
;; the window will not hide


(define base-lookup
  `((reload (load-rc))
    (repl (graphical-read-eval-print-loop))
    (about (send about-dialog show #t))
    (kill (begin (stop-server) (exit 0)))
    (cmd (system (get-after-colon inputcontents)))
    (run (disp-output (with-output-to-string (lambda () (system (get-after-colon inputcontents))))))
    (strin (begin (define matching? (make-parameter string-contains?)) #f))
    (prefix (begin (define matching? (make-parameter string-prefix?)) #f))
    (R (disp-output (with-output-to-string (lambda () (system (string-append "R --quiet -e '" (get-after-colon inputcontents) "'"))))))
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

(define unix-lookup
  '((firefox (dexec "firefox"))
    (terminal (dexec "terminal"))
    (lock (sexec "slock"))
    (gmail (sexec "firefox --new-tab 'http://gmail.com'"))
    (toodledo (sexec "firefox --new-tab 'http://tasks.toodledo.com'"))
    (notes (sexec "firefox --new-tab 'http://notes.toodledo.com'"))
    (exfalso (sexec "exfalso"))
    (veracrypt (sexec "veracrypt"))
    (settings (sexec "xfce4-settings-manager"))
    (display (exec "xfce4-display-settings"))
    (xfburn (sexec "xfburn"))
    (explorer (sexec "thunar &"))
    (music (dexec "cmus"))
    (nypl (dexec "nypl"))
    (kernel (dexec "kernel"))
    (mylua (dexec "mylua"))
    (nystec (dexec "nystec"))
    (spotify (dexec "spotify"))
    (transmission (dexec "transmission"))
    (greek (exec "setxkbmap 'gr(nodeadkeys)',us,es"))
    (spanish (exec "setxkbmap 'es,us,gr(nodeadkeys)'"))
    (english (exec "setxkbmap 'us,gr(nodeadkeys),es' && xmodmap ~/.Xmodmap"))
    (αγγλικά (exec "setxkbmap 'us,gr(nodeadkeys),es' && xmodmap ~/.Xmodmap"))
    (xmodmap (exec "xmodmap ~/.Xmodmap"))
    (whatsapp (dexec "whatsapp"))
    (chromium (dexec "chromium"))
    (signal (dexec "signal"))
    (icon (sexec "~/.zsh/more-scripts/icon-toggle.sh"))
    (gimp (dexec "gimp"))
    (screenshot (sexec "xfce4-screenshooter -r -s /home/tony/Desktop/ &"))
    (volume (sexec "xfce4-terminal -x alsamixer"))
    (unclutter (sexec "xfce4-terminal -x vi ~/notes +"))
    (dim (sexec "redshift -O 5000"))
    (evening (sexec "redshift -O 4000"))
    (night (sexec "redshift -O 2500"))
    (deepnight (sexec "redshift -O 2000"))
    (day (sexec "redshift -x"))
    (mendeley (sexec "mendeleydesktop &"))
    (shutdown (exec "xfce4-terminal -x sudo shutdown -h now"))
    (reboot (exec "xfce4-terminal -x sudo shutdown -r now"))))

(define mac-lookup
  `((firefox (mexec "Firefox"))
    (terminal (mexec "iTerm") hi)
    (macvim (mexec "MacVim") thisisatest)
    (calendar (mexec "Calendar"))
    (contacts (mexec "Contacts"))
    (whatsapp (mexec "WhatsApp"))
    (itunes (mexec "iTunes"))
    (spotify (mexec "Spotify"))
    (image-capture (mexec "Image\\ Capture"))
    (app-store (mexec "App\\ Store"))
    (mendeley (mexec "Mendeley\\ Desktop"))
    (todo (mexec "2Do"))
    (toodledo (exec "open 'http://tasks.toodledo.com'"))
    (notes (exec "open 'http://notes.toodledo.com'"))
    (monitor (mexec "Utilities/Activity\\ Monitor"))
    (gmail (exec "open 'http://gmail.com'"))
    (preview (mexec "Preview"))
    (slack (mexec "Slack"))
    (signal (mexec "Signal"))
    (messages (mexec "Messages"))
    (chrome (mexec "Google\\ Chrome"))
    (garageband (mexec "GarageBand"))
    (rstudio (mexec "RStudio"))
    (config (exec "open ~/.starlight/config.rkt"))
    (screenshot (exec "screencapture -s ~/Desktop/screenshot-`date +\"%Y-%m-%d_%H.%M.%S\"`.png"))
    (preferences (mexec "System\\ Preferences"))
    (dictionary (mexec "Dictionary"))
    (emacs (mexec "Emacs"))
    (firstsearch (exec "open 'https://firstsearch-oclc-org.i.ezproxy.nypl.org/WebZ/LogDbChange?dbchangetype=quickselect:next=html/advanced.html:bad=html/home.html:sessionid=fsapp3-42467-jtembp1t-vhomzn:entitypagenum=2:0:dbname=WorldCat'"))
    (lock (exec "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"))
    (shutdown (exec "osascript -e 'tell app \"loginwindow\" to «event aevtrsdn»'"))
    (sshutdown (exec "osascript -e 'tell app \"System Events\" to shut down'"))
    (sreboot (exec "osascript -e 'tell app \"loginwindow\" to «event aevtrrst»'"))
    (reboot (exec "osascript -e 'tell app \"System Events\" to restart'"))
    (finder (begin (set! lookup (append-base-subordinates dir-lookup)) #f))
    (applications (begin (set! lookup (append-base-subordinates (construct-dir-list (string->path "/Applications")))) #f))
    (open (let [(cmd (string-append "open /Applications/" (get-after-colon inputcontents) ".app"))] (exec cmd)))))

(define lookup '())

; (if (eq? os 'macosx) (set! lookup (append base-lookup mac-lookup)) '())
; (if (eq? os 'unix) (set! lookup (append base-lookup unix-lookup)) '())

(define (reset-top-level-lookup)
  (if (eq? os 'macosx) (set! lookup (append base-lookup mac-lookup)) '())
  (if (eq? os 'unix) (set! lookup (append base-lookup unix-lookup)) '()))

(reset-top-level-lookup)

(define for-all-subordinates
  `((back (begin (reset-top-level-lookup) #f))
    (strin (begin (define matching? (make-parameter string-contains?)) #f))
    (prefix (begin (define matching? (make-parameter string-prefix?)) #f))))

(define (append-base-subordinates asub)
  (append for-all-subordinates asub))

; subordinate lookups
(define dir-lookup
  `((dropbox (begin (reset-top-level-lookup) (exec "open ~/Dropbox/")))
    (pictures (exec "open ~/Pictures/"))
    (documents (exec "open ~/Documents/"))))

(define (construct-dir-list apath)
  (map
    (lambda (path)
      (list
        (string->symbol (path->string path))
        `(begin (reset-top-level-lookup)
                (exec (string-append "open \"" ,(path->string (path->complete-path path apath)) "\"")))))
    (directory-list apath)))
