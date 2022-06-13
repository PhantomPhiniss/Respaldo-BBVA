#!/usr/bin/ksh -v
## uncomment the following two lines for debugging
#############################################################################################
# Bancomer BBVA Mexico                                                                       #
# Archivo    : RX_MMICCDBUC0.sh                                                              #
# Autor      : E.R.R. 09/02/2017                                                             #
# OBjetivo   : Recupera el archivo IRENE_BUC.scv de SUSE /IRENE/IRENE_BC1/INV                #
#              a /etl_work/idi_fs08/EP/ep_0014_irene2/input                                  #
# Parametros : Fecha                                                                         #
# Ejecucion  : ** Semanal todos los lunes ***                                                #
# Historia   :                                                                               #
# Observaciones :                                                                            #
#                                                                                            #
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
       stepUNX1    copy from  (snode
                   file=/IRENE/IRENE_BC1/INV/IRENE_BUC.csv
                   sysopts="strip.blanks=no:datatype=text:"
                              )
                     to    (pnode
                     file=/etl_work/idi_fs08/EP/ep_0014_irene2/input/IRENE_BUC.csv
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