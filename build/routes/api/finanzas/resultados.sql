SELECT
 
  SUBSTRING(ALIAS_0.fechavencimiento,1,4) ||'/'|| SUBSTRING(ALIAS_0.fechavencimiento,5,2) ||'/'|| SUBSTRING(ALIAS_0.fechavencimiento,7,2) FECHA_ENTREGA, 
 ALIAS_7.CODIGO CODIGO, 
 ALIAS_0.DESCRIPCION DESCRIPCION, 
 sum((ALIAS_0.DEBE2_IMPORTE - ALIAS_0.HABER2_IMPORTE)) SALDO,
 IC.NOMBRE TIPOGANANCIA,
 IC1.NOMBRE TIPOMOVIMIENTO,
 IC2.NOMBRE TIPOGASTO,
 SUBSTRING(ALIAS_0.FECHAVENCIMIENTO,5,2) MES,
 SUBSTRING(ALIAS_0.FECHAVENCIMIENTO,1,4) AÑO,
 substring(alias_0.fechavencimiento,1,6) Date
 FROM  V_ITEMCONTABLE ALIAS_0  
 LEFT OUTER JOIN V_UOCONTABILIDAD ALIAS_1 ON ALIAS_0.UNIDADOPERATIVA_ID = ALIAS_1.ID   
 LEFT OUTER JOIN V_ESQUEMAOPERATIVO ALIAS_10 ON ALIAS_1.ESQUEMAOPERATIVO_ID = ALIAS_10.ID   
 LEFT OUTER JOIN V_TIPOTRANSACCION ALIAS_2 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_2.ID   
 LEFT OUTER JOIN V_TRCONTABLE ALIAS_3 ON ALIAS_0.PLACEOWNER_ID = ALIAS_3.ID   
 LEFT OUTER JOIN V_FLAG ALIAS_6 ON ALIAS_3.FLAG_ID = ALIAS_6.ID   
 LEFT OUTER JOIN V_IMPUTACIONCONTABLE ALIAS_4 ON ALIAS_0.IMPUTACIONCONTABLE_ID = ALIAS_4.ID   
 LEFT OUTER JOIN V_CENTROCOSTOS ALIAS_5 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_5.ID   
 LEFT OUTER JOIN V_CUENTA ALIAS_7 ON ALIAS_0.REFERENCIA_ID = ALIAS_7.ID   
 LEFT OUTER JOIN V_TITULOCONTABLE ALIAS_8 ON ALIAS_7.ACUMULA_ID = ALIAS_8.ID   
 LEFT OUTER JOIN V_EJERCICIO ALIAS_9 ON ALIAS_0.EJERCICIO_ID = ALIAS_9.ID   
 LEFT OUTER JOIN V_PERIODO ALIAS_11 ON ALIAS_0.PERIODO_ID = ALIAS_11.ID
 LEFT OUTER JOIN V_SUBDIARIO SUBDIARIO ON SUBDIARIO.ID = ALIAS_0.SUBDIARIO_ID  
 LEFT OUTER JOIN UD_CUENTACONTABLE CC ON CC.ID = ALIAS_7.BOEXTENSION_ID
 LEFT OUTER JOIN V_ITEMTIPOCLASIFICADOR IC ON CC.TIPOGANANCIA_ID = IC.ID
 LEFT OUTER JOIN V_ITEMTIPOCLASIFICADOR IC1 ON CC.TIPOMOVIMIENTO_ID = IC1.ID
 LEFT OUTER JOIN V_ITEMTIPOCLASIFICADOR IC2 ON CC.TIPOGASTO_ID = IC2.ID
 WHERE    
 ALIAS_0.BO_PLACE_ID IS NOT NULL     

 and alias_3.tipoasientocierre like '' 
--'' Substring(ALIAS_0.FECHAVENCIMIENTO,1,8) >= Substring(:fechadesde,1,8)  AND" & xFechaDesde & "'  
--'' Substring(ALIAS_0.FECHAVENCIMIENTO,1,8) <= Substring(:fechahasta,1,8)  AND" & xFechaHasta & "' 

 and Substring(alias_0.fechavencimiento,1,8) >= ${fechaDesde} 
 and Substring(alias_0.fechavencimiento,1,8) <= ${fechaHasta} 

 and IC.NOMBRE not like ''
 and (ALIAS_0.ESTADOTR = 'A' OR ALIAS_0.ESTADOTR = 'C') 

group by ALIAS_7.CODIGO,
	 ALIAS_0.DESCRIPCION,
	 FECHA_ENTREGA,
	-- ALIAS_0_FECHAVENCIMIENTO,
	 --saldo,
	 TIPOGANANCIA,
	 TIPOMOVIMIENTO,
	 TIPOGASTO,
	 MES,
	 AÑO,
	 Date

order by alias_7.codigo, tipomovimiento, fecha_entrega, date