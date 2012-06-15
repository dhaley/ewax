#!/bin/bash

# INSTALL SCRIPT FOR THE E-WAX emacs environment    

[ -d ~/git ] || mkdir ~/git
cd ~/git
git clone https://github.com/dhaley/dkh-foss.git foss
cd foss
#
# Get the newest ORG    
#
git submodule init org-mode
git submodule update org-mode
cd org-mode
make
cd ~/git
#
# Get default customization files    
#
git clone https://github.com/dhaley/ewax-default-files.git .emacs.d
cd ~/.emacs.d
#
# Set up the newest bbdb
#
git submodule add -f git://git.savannah.nongnu.org/bbdb.git src/bbdb
cd src/bbdb
autoconf
./configure
make
[ -d ~/git/org/client1 ] || mkdir -p ~/git/org/client1
cd ~/.emacs.d
git submodule add -f http://git.gnus.org/gnus.git src/gnus
cd ~/.emacs.d/src/gnus
./configure && make
cd ~/.emacs.d
git submodule add -f https://github.com/ananthakumaran/jquery-doc.el src/jquery-doc
git submodule add -f https://github.com/kiwanami/emacs-calfw.git src/emacs-calfw
git submodule add -f git://git.naquadah.org/erc-track-score.git src/erc-track-score
git submodule add -f https://github.com/szermatt/emacs-bash-completion.git src/emacs-bash-completion    
git submodule add -f http://git.savannah.gnu.org/cgit/identica-mode.git src/identica-mode
git submodule add -f https://github.com/underhilllabs/drupal-mode.git src/drupal-mode
