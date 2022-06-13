/usr/bin/ksh -v
## uncomment the following two lines for debugging
#############################################################################################
# Bancomer BBVA Mexico                                                                       #
# Archivo    : TX_MMICCDATS0.sh                                                              #
# Autor      : E.R.R. 09/02/2017                                                             #
# OBjetivo   : Trasmite archivo INV_FILE_AUTOSERV_AAAAMMDD.txt de ETL                        #
#              /etl_work/idi_fs08/EP/ep_0014_irene2/output/ a SUSE                           #
#              /IRENE/IRENE_BC1/INV/                                              #
# Parametros : Fecha ODATE                                                                   #
# Ejecucion  : ** De Lunes a Viernes en dias habiles 04:30 AMMXHABILE ***                    #
# Historia   :                                                                               #
# Observaciones :                                                                            #
#                                                                                            #
#############################################################################################

CDDIR=/NDM36/cdunix/
NDMAPICFG=$CDDIR/ndm/cfg/cliapi/ndmapi.cfg
fecha=$1
export NDMAPICFG
set -v

$CDDIR/ndm/bin/direct  -x << EOJ
submit maxdelay=unlimited
       procUNX     process    snode=CDLVMPRODSWCL
       stepUNX1    copy from  (pnode
                   file=/etl_work/idi_fs08/EP/ep_0014_irene2/output/INV_FILE_AUTOSERV_${fecha}
                   sysopts="strip.blanks=no:datatype=text:"
                              )
                     to    (snode
                     file=/IRENE/IRENE_BC1/INV/INV_FILE_AUTOSERV_${fecha}
                     disp=rpl
                     sysopts="strip.blanks=no:datatype=text:"
                           )
                     COMPRESS EXTENDED
pend;
EOJ

SAVE=$?
echo $SAVE$
if [[ $SAVE > 0 ]]
then
   echo "Error:$SAVE"
exit 1
fi
echo "No error"
exit 0
