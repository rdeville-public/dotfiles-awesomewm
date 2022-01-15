#!/bin/bash
# Run Awesome in a nested server for tests
#
# Requirements: (Debian)
#
#  apt-get install xserver-xephyr
#  apt-get install -t unstable awesome
#
# Based on original script by dante4d <dante4d@gmail.com>
# See: http://awesome.naquadah.org/wiki/index.php?title=Using_Xephyr
# URL: http://hellekin.cepheide.org/awesome/awesome_test
#
# Copyright (c) 2009 Hellekin O. Wolf <hellekin@cepheide.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

function usage()
{
  cat <<USAGE
awesome_test start|stop|restart|run

  start    Start nested Awesome in Xephyr
  stop     Stop Xephyr
  restart  Reload nested Awesome configuration
  run      Run command in nested Awesome

Will try to run awesome developpement that must be
in ~/.config/awesome/rc.lua.new
If it does not exist, then will run default awesome.

USAGE
  exit 0
}

# WARNING: the following two functions expect that you only run one instance
# of Xephyr and the last launched Awesome runs in it

function awesome_pid()
{
  /bin/pidof awesome | cut -d\  -f1
}

function xephyr_pid()
{
  /bin/pidof Xephyr | cut -d\  -f1
}

[ $# -lt 1 ] && usage

# If rc.lua.new is missing, make a default one.
if [[ -e "${HOME}/.config/awesome/rc.lua.new" ]]
then
  RC_LUA="${HOME}/.config/awesome/rc.lua.new"
elif [[ -e "${HOME}/.config/awesome/rc.lua" ]]
then
  RC_LUA="${HOME}/.config/awesome/rc.lua"
else
  RC_LUA="/etc/xdg/awesome/rc.lua"
fi

# Just in case we're not running from /usr/bin
AWESOME=`which awesome`
XEPHYR=`which Xephyr`

if ! command -v awesome
then
  echo "Awesome executable not found. Please install Awesome"
  exit 1
fi

if ! command -v Xephyr
then
  echo "Xephyr executable not found. Please install Xephyr"
  exit 1
fi

case "$1" in
  start)
    $XEPHYR -ac -br -noreset -screen 1880x1040 :1 &
    sleep 1
    DISPLAY=:1.0 $AWESOME -c $RC_LUA & >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
    sleep 1
    echo Awesome ready for tests. PID is $(awesome_pid)
    ;;
  stop)
    echo -n "Stopping Nested Awesome... "
    if [ -z $(xephyr_pid) ]; then
      echo "Not running: not stopped :)"
      exit 0
    else
      kill $(xephyr_pid)
      echo "Done."
    fi
    ;;
  restart)
    echo -n "Restarting Awesome... "
    kill -s SIGHUP $(awesome_pid)
    ;;
  run)
    shift
    DISPLAY=:1.0 "$@" &
    ;;
  *)
    usage
    ;;
esac
