!/bin/bash
#######################################################################################
# BBVA Mexico#
# Autor          : Diego Rodrigo Fern[andez Zamora#
# Proposito      : Shell para la ejecución del Des ofuscamiento#
####################################################################################### 

set -xv
PROCESO=CLIENTE_RESLBASR
echo "#*********************************************************************************#"
echo "#                                                                                 #"
echo "#                                                                                 #"
echo "# ========= Shell que realiza el proceso de DesOfuscamiento de ${PROCESO}    =====  #"
echo "#                                                                                 #"
echo "#                                                                                 #"
echo "#*********************************************************************************#"

#####################################
# Directorios a utilizar  #
#####################################
#INFA_HOME=/infa/infa9/PC901

ROOT_PATH=/etl_work/idi_fs08/EP/ep_0014_irene2
PATH_INPUT=${ROOT_PATH}/input
OUTPUT_PATH=${ROOT_PATH}/input
SHELLS_PATH=${ROOT_PATH}/shells

#################################################
# Variables de entorno					        #
#################################################

ISERVERIPC_DES=150.50.102.246
ISERVERIPC_PROD=150.100.43.251
SERVER_DESOFUSCA_DES=Test@150.50.102.246
SERVER_DESOFUSCA_PROD=zmpreve@150.100.43.251
INSTRUCC_DES=Desofuscamiento
INSTRUCC_PROD=./Desofuscamiento.sh
USUARIO_DES=
PASS_DES=
USUARIO_PROD=etladmin
PASS_PROD=
INPUT_FILE=ARCH_INV_VISTA_AAAAMMDD.txt
OUTPUT_FILE=ARCH_RES_VISTA_AAAAMMDD.txt

#
#################################################
# Valida el servidor en el que se encuentra     #
#################################################

SERVER=`ifconfig -a |grep $SEGMENT|awk '{print $2}'|cut -d":" -f2`

if [ "$SERVER" = "$ISERVERIPC_DES" ] 
then
   # Servidor de Desarrollo 
   
   ISERVERIPC=${ISERVERIPC_DES}
   USUARIO_SERV=${USUARIO_DES}
   PASS_SERV=${PASS_DES}
   INSTRUCC=${INSTRUCC_DES}
   SERVER_DESOFUSCA=${SERVER_DESOFUSCA_DES}
else
   # Servidor de Produccion
	ISERVERIPC=${ISERVERIPC_PROD}
	USUARIO_SERV=${USUARIO_PROD}
	PASS_SERV=${PASS_PROD}
	INSTRUCC=${INSTRUCC_PROD}
	SERVER_DESOFUSCA=${SERVER_DESOFUSCA_PROD}
fi
#################################################
# Proceso     #
#################################################

main_descofusca ()
{
   #Elimina el archivo previamente generado
   if [ -e ${OUTPUT_PATH}/${OUTPUT_FILE} ]
      then
         rm ${OUTPUT_PATH}/${OUTPUT_FILE}
   fi

   cd ${SHELLS_PATH}
   ssh ${SERVER_DESOFUSCA} ${INSTRUCC} ${PATH_INPUT}/${INPUT_FILE} ${OUTPUT_PATH}/${OUTPUT_FILE} ${ISERVERIPC} ${USUARIO_SERV} ${PASS_SERV}
   cd ${OUTPUT_PATH}


   #Verifica si el proceso genero el archivo ofuscado
   if [ -e ${OUTPUT_PATH}/${OUTPUT_FILE} ]
      then
         chmod -f 775 ${OUTPUT_PATH}/${OUTPUT_FILE}
         echo "Finaliza ejecución DesOfuscamiento ${PROCESO}"
      exit 0
   else 
      echo "Falla en el proceso de DesOfuscamiento ${PROCESO}"
      exit 1
   fi
}

#######################################
#  Ejecución de shell                 #
#######################################
echo "Comienza ejecucion DesOfuscamiento ${PROCESO}"
main_descofusca
