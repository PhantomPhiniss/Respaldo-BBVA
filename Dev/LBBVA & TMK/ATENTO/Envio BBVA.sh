!/bin/bash
#######################################################################################
# BBVA Mexico: AUTO SERVICIO INVITACION                                                #
# Archivo             : Envio de Archivo                                               #
# Autor               : Operative Scheduling                                           #
# Objetivo            : Transmite el archivo  :                                        #
#                        - Envio_BBVA		                                             #
#                       de Equipo     ruta Origen                                      #
#                       a  Entidad Externa  Ruta destino                               #
# Periodicidad        : diaria                                                         #
# Creacion            :                                                                #
#                                                                                      #
#######################################################################################

set -xv

######################################
#     Variables de directorios       #
######################################
ROOT_PATH=
PATH_SHELL=${ROOT_PATH}

NOM_ARCH=${ARCH_INV_TDC_AAAAMMDD}

# Se determina ruta ORIGEN y SERVIDOR   ########
ORIGEN=172.18.80.243
PATH_ORIGEN=F:\irene\output\               #### Ruta Origen 

# Se Determina ruta DESTINO y SERVIDOR  ########
DESTINO=150.100.230.53					                  ###  IP Equipo destino
PATH_DESTINO=\\cbnocfs15\0_CB002\CRM\ATENTO\Input\              ### Ruta Destino

cd ${PATH_SHELL}
if [ -s ${PATH_ORIGEN}/${NOM_ARCH} ]
   then
      echo "Registros en Archivo ${NOM_ARCH} : $(LINEA -l ${PATH_DESTINO}/${NOM_ARCH}|awk '{ print $1 }')"
      #Genera shell tranSFTP_entidad.sh de transmision
      NOM_ARCH_TRANSM="TX_ARCH_INV_LINEA_BBVA_AAAAMMDD.sh"
      echo "Inicia creacion de SHELL de transmision ${NOM_ARCH_TRANSM}"
      rm -f ${PATH_SHELLS}/${NOM_ARCH_TRANSM}
      echo "#Shell que transmite archivo de ${ORIGEN} a ${DESTINO}" > ${PATH_SHELL}/${NOM_ARCH_TRANSM}
      echo "lcd  ${PATH_ORIGEN}"                                   >> ${PATH_SHELL}/${NOM_ARCH_TRANSM}
      echo "cd   ${PATH_DESTINO}"                                  >> ${PATH_SHELL}/${NOM_ARCH_TRANSM}
 echo "put  ${NOM_ARCH}"                                      >> ${PATH_SHELL}/${NOM_ARCH_TRANSM}
      echo "chmod 666 ${NOM_ARCH}"                                 >> ${PATH_SHELL}/${NOM_ARCH_TRANSM}

      #Se dan permisos al nuevo archivo
      echo "Termina creacion de SHELL de transmision {NOM_ARCH_TRANSM}"

      chmod 777 ${PATH_SHELL}/${NOM_ARCH_TRANSM}

      sftp -o IdentityFile=/home/zndmsftp/.ssh/IRENE/id_rsa -b ${NOM_ARCH_TRANSM} sftp bbvabancomermexico@54.207.230.132  ###usuario e IP a donde se va a conectar

      SAVE=$?

      if [[ $SAVE > 0 ]]
      then
         if [[ $SAVE -eq 1 ]]
         then
            echo "Error:$SAVE No existe archivo en ${ORIGEN} ORIGEN ${PATH_ORIGEN}/${NOM_ARCH} *****"
            echo "            Para ${DESTINO} DESTINO ${PATH_DESTINO} *****"
       
  else
            echo "Error:$SAVE no hay comunicacion con el servidor ${DESTINO} DESTINO"
         fi
         echo "Termina Proceso de Transmision de forma ERRONEA"
         exit 1
      fi

      mv ${PATH_ORIGEN}/${NOM_ARCH} ${PATH_ORIGEN}/${NOM_ARCH}_1
      echo "Archivo Transmitido por SFTP a ${DESTINO} ${NOM_ARCH} "
      echo "Finaliza ejecucion OK"
      exit 0
else
      echo "No existe Archivo ${ORIGEN} ORIGEN ${PATH_ORIGEN}/${NOM_ARCH}"
      echo "Para ${DESTINO} DESTINO ${PATH_DESTINO} *****"
      echo "Finaliza ejecucion con ERROR"
      exit 1
fi