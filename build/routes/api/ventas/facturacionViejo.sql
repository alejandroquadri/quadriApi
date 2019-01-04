SELECT	ALIAS_0.NOMBRETR TRANSACCION, 
		ALIAS_0.ESTADOTR ESTADO, 
		ALIAS_7.DESCRIPCION FLAG, 
		SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO, 
		SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) FECHA_ENTREGA, 
		ALIAS_0.NUMERODOCUMENTO NUMERODOCUMENTO, 
		ALIAS_0.NOMBREORIGINANTETR NOMBREORIGINANTETR, 
		ALIAS_0.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR, 
		ALIAS_6.NOMBRE MONEDA, 
		ALIAS_0.COTIZACION COTIZACION, 
		ALIAS_1.CODIGO CODIGO, 
		ALIAS_9.CODIGO CODIGOCC, 
		ALIAS_9.DESCRIPCION CONCEPTOCOMERCIAL, 
		ALIAS_1.DESCRIPCION DESCRIPCION, 
		ALIAS_1.AFECTASTOCK AFECTASTOCK, 
		ALIAS_0.CANTIDAD2_CANTIDAD CANTIDAD, 
		ALIAS_0.CNOLINEAL2_CANTIDAD CANTIDAD_NL, 
		round(ALIAS_0.VALOR2_IMPORTE,2) PRECIO, 
		round(ALIAS_0.IMPORTEBONIFICADO, 2) IMPORTE_BONIFICADO, 
		round(ALIAS_0.TOTAL2_IMPORTE,2) TOTAL_IMPORTE, 
		GV.descripcion as origen,
		SEG.nombre5 as marca

FROM V_ITEMVENTA ALIAS_0

LEFT JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID 
LEFT JOIN V_SUBSUCURSAL ALIAS_2 ON ALIAS_0.SUBSUCURSAL_ID = ALIAS_2.ID 
LEFT JOIN V_SUCURSAL ALIAS_17 ON ALIAS_2.SUCURSAL_ID = ALIAS_17.ID 
LEFT JOIN V_FILIAL ALIAS_3 ON ALIAS_17.FILIAL_ID = ALIAS_3.ID 
LEFT JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID 
LEFT JOIN V_DOMICILIO ALIAS_4 ON ALIAS_5.DOMICILIOENTREGA_ID = ALIAS_4.ID 
LEFT JOIN V_PROVINCIA ALIAS_13 ON ALIAS_4.PROVINCIA_ID = ALIAS_13.ID 
LEFT JOIN V_CIUDAD ALIAS_14 ON ALIAS_4.CIUDAD_ID = ALIAS_14.ID 
LEFT JOIN V_PAIS ALIAS_15 ON ALIAS_4.PAIS_ID = ALIAS_15.ID 
LEFT JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID 
LEFT JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID 
LEFT JOIN V_TREXTENSION ALIAS_18 ON ALIAS_5.TREXTENSION_ID = ALIAS_18.ID 
LEFT JOIN V_ESQUEMAOPERATIVO ALIAS_8 ON ALIAS_18.ESQUEMAOPERATIVO_ID = ALIAS_8.ID 
LEFT JOIN V_PROYECTO ALIAS_11 ON ALIAS_5.PROYECTO_ID = ALIAS_11.ID 
LEFT JOIN V_TIPOPAGO ALIAS_16 ON ALIAS_5.TIPOPAGO_ID = ALIAS_16.ID 
LEFT JOIN V_PROYECTO ALIAS_12 ON ALIAS_0.PROYECTO_ID = ALIAS_12.ID 
LEFT JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID 
LEFT JOIN V_CENTROCOSTOS ALIAS_10 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_10.ID 
LEFT JOIN (SELECT id, boextension_id 
			FROM V_TRFACTURAVENTA
			UNION
			SELECT id, boextension_id FROM v_trcreditoventa
			UNION
			SELECT id, boextension_id FROM v_trpresupuestoventa
			UNION
			SELECT id, boextension_id FROM v_trordenventa) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID 	
LEFT JOIN (SELECT id, origenfv_id FROM UD_TRFACTURAVENTA
			UNION
			SELECT id, origennc_id FROM UD_TRNOTACREDITO
			UNION
			SELECT id, origenant_id FROM ud_tranticipo
			UNION
			SELECT id, origenfm_id FROM UD_TRFACTURAVENTAMOS        
			UNION
			SELECT id, origenpsp_id FROM UD_TRPRESUPUESTOVENTA
			UNION
			SELECT id, origennv_id FROM UD_NOTAVENTA) UD ON TRF.BOEXTENSION_ID = UD.ID 
LEFT JOIN grupovistas GV on GV.id = UD.origenFV_id
LEFT JOIN producto b on ALIAS_0.nombrereferencia = b.codigo
LEFT JOIN segmento SEG on b.segmento_id = seg.id
	
WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL 
AND substring(ALIAS_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
AND substring(ALIAS_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)
-- AND substring(ALIAS_0.fechadocumento,1,8) >= substring('20180101',1,8)
-- AND substring(ALIAS_0.fechadocumento,1,8)<= substring('20180123',1,8)
AND ALIAS_0.ESTADOTR = 'C'
AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND ALIAS_1.codigo not like 'VT05;RES-;tt-' 
AND ALIAS_1.codigo not like 'VT02'
AND ALIAS_1.codigo not like 'VT01'
AND ALIAS_1.codigo not like 'VT10;RES-;'
AND ALIAS_1.codigo not like 'VT09;RES+;'
AND ALIAS_1.codigo not like 'VT06;VENTAS-;RES-;' 
AND ALIAS_1.codigo not like 'VT14' 
AND ALIAS_1.codigo not like 'VT03'

GROUP BY 	ALIAS_0.NOMBRETR , 
			ALIAS_0.ESTADOTR , 
			ALIAS_7.DESCRIPCION , 
			SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) , 
			SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) , 
			ALIAS_0.NUMERODOCUMENTO , 
			ALIAS_0.NOMBREORIGINANTETR , 
			ALIAS_0.NOMBREDESTINATARIOTR , 
			ALIAS_6.NOMBRE , 
			ALIAS_0.COTIZACION , 
			ALIAS_1.CODIGO , 
			ALIAS_9.CODIGO , 
			ALIAS_9.DESCRIPCION , 
			ALIAS_1.DESCRIPCION , 
			ALIAS_1.AFECTASTOCK , 
			ALIAS_0.CANTIDAD2_CANTIDAD , 
			ALIAS_0.CNOLINEAL2_CANTIDAD , 
			round(ALIAS_0.VALOR2_IMPORTE,2) , 
			round(ALIAS_0.IMPORTEBONIFICADO, 2) , 
			round(ALIAS_0.TOTAL2_IMPORTE,2) , 
			GV.descripcion  ,
			SEG.nombre5																															

UNION ALL

SELECT 	ALIAS_0.NOMBRETR TRANSACCION, 
		ALIAS_0.ESTADOTR ESTADO, 
		ALIAS_7.DESCRIPCION FLAG, 
		SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO, 
		SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) FECHA_ENTREGA, 
		ALIAS_0.NUMERODOCUMENTO NUMERODOCUMENTO, 
		ALIAS_0.NOMBREORIGINANTETR NOMBREORIGINANTETR, 
		ALIAS_0.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR, 
		ALIAS_6.NOMBRE MONEDA, 
		ALIAS_0.COTIZACION COTIZACION, 
		ALIAS_1.CODIGO CODIGO, 
		ALIAS_9.CODIGO CODIGOCC, 
		ALIAS_9.DESCRIPCION CONCEPTOCOMERCIAL, 
		ALIAS_1.DESCRIPCION DESCRIPCION, 
		ALIAS_1.AFECTASTOCK AFECTASTOCK, 
		ALIAS_0.CANTIDAD2_CANTIDAD CANTIDAD, 
		ALIAS_0.CNOLINEAL2_CANTIDAD CANTIDAD_NL, 
		round(-(ALIAS_0.VALOR2_IMPORTE),2) PRECIO, 
		round(-(ALIAS_0.IMPORTEBONIFICADO),2) IMPORTE_BONIFICADO, 
		round(-(ALIAS_0.TOTAL2_IMPORTE),2) TOTAL_IMPORTE, 
		GV.descripcion as origen,
		SEG.nombre5 as marca

FROM V_ITEMVENTA ALIAS_0
LEFT JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID
LEFT JOIN V_SUBSUCURSAL ALIAS_2 ON ALIAS_0.SUBSUCURSAL_ID = ALIAS_2.ID
LEFT JOIN V_SUCURSAL ALIAS_17 ON ALIAS_2.SUCURSAL_ID = ALIAS_17.ID
LEFT JOIN V_FILIAL ALIAS_3 ON ALIAS_17.FILIAL_ID = ALIAS_3.ID
LEFT JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID
LEFT JOIN V_DOMICILIO ALIAS_4 ON ALIAS_5.DOMICILIOENTREGA_ID = ALIAS_4.ID
LEFT JOIN V_PROVINCIA ALIAS_13 ON ALIAS_4.PROVINCIA_ID = ALIAS_13.ID
LEFT JOIN V_CIUDAD ALIAS_14 ON ALIAS_4.CIUDAD_ID = ALIAS_14.ID
LEFT JOIN V_PAIS ALIAS_15 ON ALIAS_4.PAIS_ID = ALIAS_15.ID
LEFT JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID
LEFT JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID
LEFT JOIN V_TREXTENSION ALIAS_18 ON ALIAS_5.TREXTENSION_ID = ALIAS_18.ID 
LEFT JOIN V_ESQUEMAOPERATIVO ALIAS_8 ON ALIAS_18.ESQUEMAOPERATIVO_ID = ALIAS_8.ID 
LEFT JOIN V_PROYECTO ALIAS_11 ON ALIAS_5.PROYECTO_ID = ALIAS_11.ID 
LEFT JOIN V_TIPOPAGO ALIAS_16 ON ALIAS_5.TIPOPAGO_ID = ALIAS_16.ID 
LEFT JOIN V_PROYECTO ALIAS_12 ON ALIAS_0.PROYECTO_ID = ALIAS_12.ID 
LEFT JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID 
LEFT JOIN V_CENTROCOSTOS ALIAS_10 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_10.ID 
LEFT JOIN (
		SELECT id, boextension_id from V_TRFACTURAVENTA
		UNION
		SELECT id, boextension_id from v_trcreditoventa
		UNION
		SELECT id, boextension_id from v_trpresupuestoventa
		UNION
		SELECT id, boextension_id from v_trordenventa) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID 	

 		LEFT JOIN (SELECT id, origenfv_id from UD_TRFACTURAVENTA
		UNION
		SELECT id, origennc_id from UD_TRNOTACREDITO
		UNION
		SELECT id, origenant_id from ud_tranticipo
		UNION
		SELECT id, origenfm_id from UD_TRFACTURAVENTAMOS        
		UNION
		SELECT id, origenpsp_id from UD_TRPRESUPUESTOVENTA
		UNION
		SELECT id, origennv_id from UD_NOTAVENTA
		) UD ON TRF.BOEXTENSION_ID = UD.ID 
LEFT JOIN grupovistas GV on GV.id = UD.origenFV_id
LEFT JOIN producto b on ALIAS_0.nombrereferencia = b.codigo
LEFT JOIN segmento SEG on b.segmento_id = seg.id

WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL 
AND substring(ALIAS_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
AND substring(ALIAS_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)
-- AND substring(ALIAS_0.fechadocumento,1,8) >= substring('20180101',1,8)
-- AND substring(ALIAS_0.fechadocumento,1,8)<= substring('20180123',1,8)
AND ALIAS_0.ESTADOTR = 'C' 
AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND ALIAS_1.codigo not like 'VT13;VENTAS+;RES+;'
AND ALIAS_1.codigo not like 'VT03;VENTAS+;RES+;'
AND ALIAS_1.codigo not like 'VT11;VENTAS+;RES+;'
AND ALIAS_1.codigo not like 'VT04;RES+;'
AND ALIAS_1.codigo not like 'VT02'
AND ALIAS_1.codigo not like 'VT01'
AND ALIAS_1.codigo not like 'VT10;RES-;'
AND ALIAS_1.codigo not like 'VT09;RES+;'
AND ALIAS_1.codigo not like 'VT14'
AND ALIAS_1.codigo not like 'VT03'

ORDER BY FECHA_DOCUMENTO ASC