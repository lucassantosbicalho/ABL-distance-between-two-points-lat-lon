/*---------------------------------------------------------------------------------
 Programa.: dist-coord-geo.p                                               
 Funcao...: Calculate distance in meters between two points (lat_1, lon_1, lat_2, lon_2)
 Autor....: Lucas Bicalho                                           Data: 16/03/2023
---------------------------------------------------------------------------------*/

&GLOBAL-DEFINE pi 3.14159265358979323846
&GLOBAL-DEFINE Earth_radius_km 6371

/* ************************  Function Prototypes ********************** */
FUNCTION fcToRad RETURNS DECIMAL 
    (INPUT ipdValor AS DECIMAL) FORWARD.


/* **********************  Internal Procedures  *********************** */

PROCEDURE prCalculateDistance:
/*------------------------------------------------------------------------------
 Purpose: Calculate the distance between two points (lat_1, lon_1, lat_2, lon_2)
 Notes: Inputs: (lat_1, lon_1, lat_2, lon_2)
        Output: distance in meters
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  ipdLat1       AS DECIMAL DECIMALS 8 NO-UNDO.
    DEFINE INPUT PARAMETER  ipdLon1       AS DECIMAL DECIMALS 8 NO-UNDO.
    DEFINE INPUT PARAMETER  ipdLat2       AS DECIMAL DECIMALS 8 NO-UNDO.
    DEFINE INPUT PARAMETER  ipdLon2       AS DECIMAL DECIMALS 8 NO-UNDO.
    DEFINE OUTPUT PARAMETER opdDistancia  AS DECIMAL DECIMALS 4 NO-UNDO.
    
    DEFINE VARIABLE dradLat    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE dradLon    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE radLat1    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE radLat2    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE sindLat    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE sindLon    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE cosLat1    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE cosLat2    AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE atanA      AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE a          AS DECIMAL DECIMALS 10 NO-UNDO.
    DEFINE VARIABLE c          AS DECIMAL DECIMALS 10 NO-UNDO.
    
    // Calc delta lat1 e lat2
    dradLat = fcToRad(ipdLat2 - ipdLat1).    
    // Calc delta lon1 e lon2
    dradLon = fcToRad(ipdLon2 - ipdLon1).
    // Transform Lat1 and Lat2 from degree to radius
    radLat1 = fcToRad(ipdLat1).
    radLat2 = fcToRad(ipdLat2).
    
    // Calc sin and cos
    RUN sin (INPUT (dradLat / 2), OUTPUT sindLat).
    RUN sin (INPUT (dradLon / 2), OUTPUT sindLon).
    RUN cos (INPUT (radLat1 / 2), OUTPUT cosLat1).
    RUN cos (INPUT (radLat2 / 2), OUTPUT cosLat2).
    
    // Calc a
    a = (sindLat * sindLat) + ( (sindLon * sindLon) * cosLat1 * cosLat2 ). 
    
    // Calc c
    // Calc atan
    RUN atan( INPUT ( SQRT(a) / SQRT( (1 - a) ) ), OUTPUT atanA ). // atan( y / a )
    c = ( 2 * atanA ). 
    
    // Calcula d
    opdDistancia = {&Earth_radius_km} * c.
END PROCEDURE.

/* Define entry points for library routines */
/* https://community.progress.com/s/article/18120 */
PROCEDURE sin EXTERNAL "MSVCRT.DLL" CDECL:
  DEFINE INPUT  PARAMETER dblValue  AS DOUBLE NO-UNDO.
  DEFINE RETURN PARAMETER dblResult AS DOUBLE NO-UNDO.
END PROCEDURE.

PROCEDURE cos EXTERNAL "MSVCRT.DLL" CDECL:
  DEFINE INPUT  PARAMETER dblValue  AS DOUBLE NO-UNDO.
  DEFINE RETURN PARAMETER dblResult AS DOUBLE NO-UNDO.
END PROCEDURE.

PROCEDURE atan EXTERNAL "MSVCRT.DLL" CDECL:
  DEFINE INPUT  PARAMETER dblValue  AS DOUBLE NO-UNDO.
  DEFINE RETURN PARAMETER dblResult AS DOUBLE NO-UNDO.
END PROCEDURE.



/* ************************  Function Implementations ***************** */

FUNCTION fcToRad RETURNS DECIMAL 
    (INPUT ipdValor AS DECIMAL):
/*------------------------------------------------------------------------------
 Purpose: Transform from degree to radius
 Notes:
------------------------------------------------------------------------------*/    
    
    RETURN (ipdValor *  {&pi}) / 180.
        
END FUNCTION.
