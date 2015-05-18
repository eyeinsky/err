# requires: proxychains, ssh, mplayer

# put this in '~/.err' 
#     SOC=.err-socket
#     USR=user
#     SRV=domain
#     SSH_PORT=22
#     LOCAL_PORT=7080

source ~/.err


getUrl() {
   # TODO
   # download from 
   #  - http://otse.err.ee/xml/etv.js
   #  - http://otse.err.ee/xml/etv2.js
   # and find least loaded server
   echo 'rtsp://wowza4.err.ee:80/live'
   }

withProxy() {
   DO="$1"
   ssh -MS $SOC -f -N -p$SSH_PORT -D$LOCAL_PORT $USR@$SRV
   proxychains $DO
   ssh -S $SOC -O exit $SRV
   }


BASE=$(getUrl)

case "$1" in
   etv | etv2 )
      if [ "$2" == "noproxy" ]
      then mplayer $BASE/$1
      else withProxy "mplayer $BASE/$1"
      fi
      ;;
   * ) echo no such channel
      ;;
esac
