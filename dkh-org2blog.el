
(require 'netrc)
(setq abq-netrc-vc
      (netrc-machine (netrc-parse "~/.netrc") "wordpress" t))

       (setq org2blog/wp-blog-alist
                '(("wordpress"
                   :url "http://host.org/xmlrpc.php"
                   :username (netrc-get abq-netrc-vc "login")
                   :password (netrc-get abq-netrc-vc "password")
                   :default-title "Hello World"
                   :default-categories ("Emacs")
                   :tags-as-categories t)
                  ))


(setq org2blog/wp-track-posts (list "~/git/dkh-org/wordpress/logs" "Posts"))

(message "0 dkh-org2blog... Done")
