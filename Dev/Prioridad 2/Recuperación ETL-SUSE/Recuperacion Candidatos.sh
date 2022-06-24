!/bin/bash
#######################################################################################
# BBVA Mexico: AUTO SERVICIO INVITACION                                                #
# Archivo             : Recuperacion BBVA                                              #
# Autor               : Diego Rodrigo Fernández Zamora                                 #
# Objetivo            : Recupera el archivo :RX_MX_ARCH_RES_CANDIDATOS_AAAAMMDD           #
# Periodicidad        : Mensual                                                        #
# Creacion            :                                                                #
# Genera              : SHELL que RECSFTP.sh  que realiza la Recuperación              #
#######################################################################################

set -xv

######################################
#     Variables de directorios       #
######################################

ROOT_PATH_=/filesystem/sftptrans/Qualtrics   ###Ruta donde esta la carpeta de scripts

PATH_SHELLS=${ROOT_PATH}scripts   ###Ruta donde están los scripts
#### Nombre del archivo
NOM_ARCH=${RX_MX_ARCH_RES_CANDIDATOS_AAAAMMDD}
NOM_ARCH_SHELL="RX_MX_ARCH_RES_CANDIDATOS_AAAAMMDD.sh"  


#Se determina RUTA ORIGEN Entidad_Externa
PATH_Entidad_Externa=Ruta_entidad_externa
#Se determina RUTA DESTINO SUSE
PATH_SUSE=/transftp/Qualtrics/carpeta_final

#######################################
#  Ejecución de shell                 #
#######################################
echo 'Comienza ejecucion'

# Genera shell RECSFTP_entidad.sh de recuperacion
  rm -f ${PATH_SHELL}/${NOM_ARCH_SHELL}
  echo "#Shell recupera archivo de Entidad_Externa a SUSE "  > ${PATH_SHELL}/${NOM_ARCH_SHELL}
  echo "lcd ${PATH_SUSE}"                            >> ${PATH_SHELL}/${NOM_ARCH_SHELL}
  echo "cd  ${PATH_Entidad-Externa}"                 >> ${PATH_SHELL}/${NOM_ARCH_SHELL}
  echo "get ${NOM_ARCH}"                             >> ${PATH_SHELL}/${NOM_ARCH_SHELL}



#Se dan permisos al nuevo archivo
 chmod 777 ${PATH_SHELLS}/${NOM_ARCH_SHELLS}
cd ${PATH_SHELLS}
sftp -o IdentityFile=/home/zndmsftp/.ssh/IRENE/id_rsa -b ${NOM_ARCH_TRANSM} sftp bbvabancomermexico@54.207.230.132  ###usuario e IP a donde se va a conectar


SAVE=$?
echo $SAVE$
if [[ $SAVE > 0 ]]
then
   if [[ $SAVE -eq 1 ]]
   then
       echo "Error:$SAVE no existe Archivo ${PATH_SUSE}/${NOM_ARCH}"
       echo "Verificar la existencia en Entidad_Externa ${PATH_Entidad-Externa}"
   else
       echo "Error:$SAVE no hay Comunicación con servidor Entidad_Externa"
   fi
 echo "Termina Proces de Transmision "
 exit 1
fi


echo "Recupera Archivo por SFTP"
echo "Finaliza ejecución OK "


if [ -s ${PATH_SUSE}/${NOM_ARCH} ]
then
    chmod 666 ${PATH_SUSE}/${NOM_ARCH}
    echo "Archivo TRANSMITIDO ${PATH_SUSE}/${NOM_ARCH}"
    exit 0
else
    echo "No existe Archivo en SalesForce ${PATH_SUSE}/${NOM_ARCH}"
    exit 1
fi
