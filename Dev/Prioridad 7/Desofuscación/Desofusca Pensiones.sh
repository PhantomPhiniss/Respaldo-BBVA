!/bin/bash
#######################################################################################
# Bancomer BBVA Mexico
# Archivo        : EP_0014_d_RQ062.sh 
# Autor          : INDRA
# Proposito      : Shell para la ejecución del Des ofuscamiento - CLIENTE LBMR ASESOR.
# Parametros     : 
# Ejecucion      : ****Preguntar la fecha y hora de ejecucion***
# Historia            : 20151201 --> Creacion 
# Caja de Control - M :  *******Preguntar por caja de control-M****
# Observaciones       : 
# Dependencias        : 
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

#
#################################################
# Variables de entorno					        #
#################################################
ISERVERIPC_DES=150.50.102.246
ISERVERIPC_PROD=150.100.246.100
SEGMENT=150.50.102
SERVER_DESOFUSCA_DES=Test@150.100.229.134
#SERVER_DESOFUSCA_PROD=zmpreve@150.100.229.118
SERVER_DESOFUSCA_PROD=zmpreve@150.100.191.147
INSTRUCC_DES=Desofuscamiento
INSTRUCC_PROD=./Desofuscamiento.sh
USUARIO_DES=xm06221
PASS_DES=IRENE0617
USUARIO_PROD=etladmin
PASS_PROD=
INPUT_FILE=CLIE_OFUS_BPYPREL.txt
OUTPUT_FILE=Clie_BPYPREL_desofuscado.txt

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
