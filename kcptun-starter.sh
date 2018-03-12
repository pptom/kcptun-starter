#!/bin/sh
#该脚本为启动关闭重启kcptun
###################################

#程序名
APP_NAME=kcptun-starter
#kcptun的目录
APP_PATH=/opt/kcptun-starter/
#kcptun server
KCPTUN_SERVER=server_linux_amd64
#配置文件路径
CONFIG_PATH=/opt/kcptun-starter/server-config.json
#日志文件
LOG_PATH=/opt/kcptun-starter/kcptun.log
#执行程序启动所使用的系统用户，考虑到安全，推荐不使用root帐号
RUNNING_USER=root

#初始化psid变量（全局）
psid=0

###################################
#(函数)启动
###################################
start() {
   checkpid
   if [ $psid -ne 0 ]; then
      echo "================================"
      echo "warn: $APP_NAME already started! (pid=$psid)"
      echo "================================"
   else
      echo -n "Starting $APP_NAME ..."
      KCPTUN_CMD="$APP_PATH$KCPTUN_SERVER -c $CONFIG_PATH >/dev/null 2>&1 &"
      su - $RUNNING_USER -c "$KCPTUN_CMD"
      checkpid
      if [ $psid -ne 0 ]; then
         echo "(pid=$psid) [OK]"
      else
         echo "[Failed]"
      fi
   fi
}

checkpid() {
   starter=`ps -ef | grep $KCPTUN_SERVER | grep -v grep`
   if [ -n "$starter" ]; then
	  psid=`echo $starter | awk '{print $2}'`
   else
      psid=0
   fi
}

###################################
#(函数)停止
###################################
stop() {
   checkpid
   if [ $psid -ne 0 ]; then
      echo -n "Stopping $APP_NAME ...(pid=$psid) "
      su - $RUNNING_USER -c "kill -9 $psid"
      if [ $? -eq 0 ]; then
         echo "[OK]"
      else
         echo "[Failed]"
      fi
      checkpid
      if [ $psid -ne 0 ]; then
         stop
      fi
   else
      echo "================================"
      echo "warn: $APP_NAME is not running"
      echo "================================"
   fi
}

###################################
#(函数)日志
###################################
log() {
   tail -f $LOG_PATH
}

###################################
#(函数)检查程序运行状态
#
#说明：
#1. 首先调用checkpid函数，刷新$psid全局变量
#2. 如果程序已经启动（$psid不等于0），则提示正在运行并表示出pid
#3. 否则，提示程序未运行
###################################
status() {
   checkpid
   if [ $psid -ne 0 ];  then
      echo "$APP_NAME is running! (pid=$psid)"
   else
      echo "$APP_NAME is not running"
   fi
}


###################################
#读取脚本的第一个参数($1)，进行判断
#参数取值范围：{start|stop|restart|status|info}
#如参数不在指定范围之内，则打印帮助信息
###################################
case "$1" in
   'start')
      start
      ;;
   'stop')
     stop
     ;;
   'restart')
     stop
     start
     ;;
	'log')
	 log
	 ;;
	'status')
	 status
	 ;;
  *)
     echo "Usage: $0 {start|stop|restart|status|log}"
     exit 1
esac
exit 0