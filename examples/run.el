;; org-mode
(find-file "org.org")
(org-shifttab 10)
(redisplay)
(call-process "import" nil nil nil "org.png")

;; dired
(dired ".")
(redisplay)
(call-process "import" nil nil nil "dired.png")

;; ivy
(find-file "ivy.py")
(defun ivy-screenshot ()
  (interactive)
  (redisplay)
  (call-process "import" nil nil nil "ivy.png"))
(progn
  (run-at-time nil nil #'ivy-screenshot)
  (swiper "= '"))
