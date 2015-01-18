#!/bin/bash

COMMAND="$GAME_DIR/srcds_run -steam_dir $STEAM_DIR -steamcmd_script $STEAM_CMD $OPTIONS"
ENTER=`echo -ne '\015'`

execute() {
  su $USERNAME -c "$*"
}

game_isrunning() {
  execute screen -ls | grep -q "$SCREEN"
  return $?
}

game_start() {
  if game_isrunning ; then
    echo "$SERVICE is already running!"
  else
    echo "Starting $SERVICE..."
    execute screen -h 128 -dmS $SCREEN $COMMAND
    execute screen -S $SCREEN -p 0 -X hardcopy_append off
    sleep 1
    if game_isrunning ; then
      echo "$SERVICE is now running."
    else
      echo "FAILED to start $SERVICE!"
    fi
  fi
}

game_stop() {
  if game_isrunning ; then
    echo "Stopping $SERVICE..."
    execute screen -S $SCREEN -p 0 -X stuff "\"say Stopping server in 5 seconds$ENTER\""
    sleep 5
    execute screen -S $SCREEN -p 0 -X stuff "\"exit$ENTER\""
    sleep 1
    execute screen -S $SCREEN -X quit 2> /dev/null # some servers (tf2) will respawn, others will exit on their own
    sleep 1
    if game_isrunning ; then
      echo "FAILED to stop $SERVICE."
    else
      echo "$SERVICE successfully stopped."
    fi
  else
    echo "$SERVICE is not running!"
  fi
}

game_rcon() {
  if game_isrunning ; then
    CMD="$@"
    execute screen -S $SCREEN -p 0 -X stuff "\"$CMD$ENTER\""
    sleep .5
    execute screen -S $SCREEN -p 0 -X hardcopy -h $LOGFILE
    (tac $LOGFILE | sed -e '/^'"$CMD"'$/,$d' | tac) 2> /dev/null
  else
    echo "$SERVICE is not running!"
  fi
}

if [ "$EUID" -ne 0 ] ; then
  echo "Root is required"
  exit 1
fi
case "$1" in
  start)
    game_start
    ;;
  stop)
    game_stop
    ;;
  restart)
    game_stop
    if ! game_isrunning ; then
      game_start
    fi
    ;;
  status)
    if game_isrunning ; then
      echo "$SERVICE is running"
    else
      echo "$SERVICE is not running"
    fi
    ;;
  rcon)
    shift
    game_rcon "$@"
    ;;
  *)
    echo "Usage: `basename $0` {start|stop|restart|status|command <command>}"
    exit 1
    ;;
esac

exit 0
