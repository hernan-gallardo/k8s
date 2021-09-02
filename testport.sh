#!/bin/bash
IP=`cat $1`
for SERVER in ${IP}
do
netcat -z ${SERVER} $2
if [ $? -eq 0 ]
then
echo «${SERVER}: Conexion Aceptada al Puerto $2»
else
echo «${SERVER}: Conexion Rechazada al Puerto $2»
fi
done