!/bin/bash
#######################################################################################
# Bancomer BBVA Mexico
# Archivo        : 
# Autor          : Diego Rodrigo Fernández Zamora
# Proposito      : Shell para la ejecución del Ofuscamiento - 
# Parametros     : 
# Ejecucion      : ****Preguntar la fecha y hora de ejecucion***
# Historia            : 20140924 --> Creacion 
# Caja de Control - M :  *******Preguntar por caja de control-M****
####################################################################################### 

set -xv
PROCESO=SEGMENTO_BPYPREL
echo "#*********************************************************************************#"
echo "#                                                                                 #"
echo "#                                                                                 #"
echo "# ========= Shell que realiza el proceso de Ofuscamiento de ${PROCESO} =========  #"
echo "#                                                                                 #"
echo "#                                                                                 #"
echo "#*********************************************************************************#"

#####################################
# Directorios a utilizar por el shell #
#####################################

ROOT_PATH=/etl_work/idi_fs08/EP/ep_0014_irene2
PATH_INPUT=${ROOT_PATH}/output
OUTPUT_PATH=${ROOT_PATH}/output
SHELLS_PATH=${ROOT_PATH}/shells
PARAMETERS_PATH=${ROOT_PATH}/config

#
#
#################################################
# Variables de entorno					        #
#################################################

ISERVERIPC_DES=
ISERVERIPC_PROD=
SEGMENT=
SERVER_OFUSCA_DES=Test@150.100.229.134
SERVER_OFUSCA_PROD=zmpreve@150.100.229.118
SERVER_OFUSCA_PROD=zmpreve@150.100.191.147
INSTRUCC_DES=Ofuscamiento
INSTRUCC_PROD=./Ofuscamiento.sh
USUARIO_DES=
PASS_DES=
USUARIO_PROD=etladmin
PASS_PROD=
INPUT_FILE=
OUTPUT_FILE=

#
#################################################
# Valida el servidor en el que se encuentra     #
#################################################

SERVER=`ifconfig -a |grep $SEGMENT|awk '{print $2}'|cut -d":" -f2`

if [ "$SERVER" = "$ISERVERIPC_DES" ] 
then
   # Servidor de Desarrollo 
   #
   ISERVERIPC=${ISERVERIPC_DES}
   USUARIO_SERV=${USUARIO_DES}
   PASS_SERV=${PASS_DES}
   INSTRUCC=${INSTRUCC_DES}
   SERVER_OFUSCA=${SERVER_OFUSCA_DES}
else
   # Servidor de Produccion
	ISERVERIPC=${ISERVERIPC_PROD}
	USUARIO_SERV=${USUARIO_PROD}
	PASS_SERV=${PASS_PROD}
	INSTRUCC=${INSTRUCC_PROD}
	SERVER_OFUSCA=${SERVER_OFUSCA_PROD}
fi

#################################################
# Proceso                                       #
#################################################

main_ofusca ()
{
   #Elimina el archivo previamente generado
   if [ -e ${OUTPUT_PATH}/${OUTPUT_FILE} ]
   then
      rm -f ${OUTPUT_PATH}/${OUTPUT_FILE}
   fi

   #echo 'Comienza ejecución Ofuscamiento ${PROCESO}' 
   cd ${ROOT_PATH}
   ssh ${SERVER_OFUSCA} ${INSTRUCC} ${PATH_INPUT}/${INPUT_FILE} ${OUTPUT_PATH}/${OUTPUT_FILE} ${ISERVERIPC} ${USUARIO_SERV} ${PASS_SERV}
   cd ${OUTPUT_PATH}

   #Verifica si el proceso genero el archivo ofuscado
   if [ -e ${OUTPUT_PATH}/${OUTPUT_FILE} ]
      then
         chmod -f 666 ${OUTPUT_PATH}/${OUTPUT_FILE}
         echo "Finaliza ejecución Ofuscamiento ${PROCESO}"
         exit 0
   else 
      echo "Falla en el proceso de Ofuscamiento ${PROCESO}"
      exit 1
   fi
}



#######################################
#  Ejecución de shell                 #
#######################################
if [ -s ${OUTPUT_PATH}/${INPUT_FILE} ] 
then
   echo "Comienza ejecucion Ofuscamiento ${PROCESO}"
   main_ofusca

else
   echo "Archivo de Entrada esta Vacio o no Existe: ${INPUT_FILE}"
   echo "No se llevo acabo el Ofuscamiento: ${PROCESO}"
 
 
   #Elimina el archivo previamente generado
   if [ -e ${OUTPUT_PATH}/${OUTPUT_FILE} ]
   then
      rm -f ${OUTPUT_PATH}/${OUTPUT_FILE}
   fi
  
   cd ${OUTPUT_PATH}
   touch  ${OUTPUT_FILE}
   chmod 666 ${OUTPUT_PATH}/${OUTPUT_FILE}
   exit 0
fi
