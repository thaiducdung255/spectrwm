#!/bin/bash

res=$(xmessage -buttons Shutdown,Restart,Logout,Cancel -print "Power ?")

case $res in
  Shutdown)
    shutdown now
    ;;

  Restart)
    shutdown -r now
    ;;

  Logout)
    ;;

  esac
