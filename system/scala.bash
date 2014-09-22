export JAVA_HOME=$(/usr/libexec/java_home)

export SCALA_HOME=/usr/local/Cellar/scala/2.11.1/libexec
export JAVACMD=drip
export DRIP_SHUTDOWN=30
export SBT_OPTS="-XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:PermSize=128M -XX:MaxPermSize=512M"