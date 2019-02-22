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
				ALIAS_0.VALOR2_IMPORTE PRECIO, 
				ALIAS_0.IMPORTEBONIFICADO IMPORTE_BONIFICADO, 
				ALIAS_0.TOTAL2_IMPORTE TOTAL_IMPORTE, 
				gv.descripcion as origen,
				UNIDADES.NOMBRE unidad,
        '' AS tipo_pago,
        ALIAS_5.valortotal total_transaccion,
        (ALIAS_5.valortotal - ALIAS_5.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem

FROM 			V_ITEMVENTA ALIAS_0 

LEFT JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID 
LEFT JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID 
LEFT JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID 
LEFT JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID 
LEFT JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID 
 
LEFT JOIN (
						SELECT id, boextension_id FROM V_TRFACTURAVENTA
						UNION
						SELECT id, boextension_id FROM v_trcreditoventa
						UNION
						SELECT id, boextension_id FROM v_trpresupuestoventa
						UNION
						SELECT id, boextension_id FROM v_trordenventa
					) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID 	

LEFT JOIN (
						SELECT id, origenfv_id FROM UD_TRFACTURAVENTA
						UNION
						SELECT id, origennc_id FROM UD_TRNOTACREDITO
						UNION
						SELECT id, origenant_id FROM ud_tranticipo
						UNION
						SELECT id, origenfm_id FROM UD_TRFACTURAVENTAMOS        
						UNION
						SELECT id, origenpsp_id FROM UD_TRPRESUPUESTOVENTA
						UNION
						SELECT id, origennv_id FROM UD_NOTAVENTA
					) UD ON TRF.BOEXTENSION_ID = UD.ID 

LEFT JOIN grupovistas GV on GV.id = UD.origenFV_id

-- agrego
LEFT JOIN v_impuestotransaccion tImp ON ALIAS_5.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON ALIAS_0.impuestositemtransaccion_id = tiImp.bo_place_id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON ALIAS_0.UNIDADMEDIDA_ID = UNIDADES.ID 
	
WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL 

AND SUBSTRING(alias_0.fechadocumento,1,8) >= SUBSTRING(${fechaDesde},1,8)
AND SUBSTRING(alias_0.fechadocumento,1,8)<= SUBSTRING(${fechaHasta},1,8)

-- AND SUBSTRING(alias_0.fechadocumento,1,8) >= SUBSTRING('20160701',1,8)
-- AND SUBSTRING(alias_0.fechadocumento,1,8)<= SUBSTRING('20170727',1,8)

AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND  alias_1.codigo like 'VT03'
	
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
				-(ALIAS_0.VALOR2_IMPORTE) PRECIO, 
				-(ALIAS_0.IMPORTEBONIFICADO) IMPORTE_BONIFICADO, 
				-(ALIAS_0.TOTAL2_IMPORTE) TOTAL_IMPORTE, 
				gv.descripcion as origen,
				UNIDADES.NOMBRE unidad,
        '' AS tipo_pago,
        ALIAS_5.valortotal total_transaccion,
        (ALIAS_5.valortotal - ALIAS_5.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem

FROM 			V_ITEMVENTA ALIAS_0 

LEFT JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID 
LEFT JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID 
LEFT JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID 
LEFT JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID 
LEFT JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID 
LEFT JOIN V_CENTROCOSTOS ALIAS_10 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_10.ID 
LEFT JOIN (
						SELECT id, boextension_id FROM V_TRFACTURAVENTA
						UNION
						SELECT id, boextension_id FROM v_trcreditoventa
						UNION
						SELECT id, boextension_id FROM v_trpresupuestoventa
						UNION
						SELECT id, boextension_id FROM v_trordenventa
					) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID 	

LEFT JOIN (
						SELECT id, origenfv_id FROM UD_TRFACTURAVENTA
						UNION
						SELECT id, origennc_id FROM UD_TRNOTACREDITO
						UNION
						SELECT id, origenant_id FROM ud_tranticipo
						UNION
						SELECT id, origenfm_id FROM UD_TRFACTURAVENTAMOS        
						UNION
						SELECT id, origenpsp_id FROM UD_TRPRESUPUESTOVENTA
						UNION
						SELECT id, origennv_id FROM UD_NOTAVENTA
					) UD ON TRF.BOEXTENSION_ID = UD.ID 

LEFT JOIN grupovistas GV on GV.id = UD.origenFV_id

--agergo
LEFT JOIN v_impuestotransaccion tImp ON ALIAS_5.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON ALIAS_0.impuestositemtransaccion_id = tiImp.bo_place_id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON ALIAS_0.UNIDADMEDIDA_ID = UNIDADES.ID 

WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL 
AND SUBSTRING(alias_0.fechadocumento,1,8) >= SUBSTRING(${fechaDesde},1,8)
AND SUBSTRING(alias_0.fechadocumento,1,8)<= SUBSTRING(${fechaHasta},1,8)

-- AND SUBSTRING(alias_0.fechadocumento,1,8) >= SUBSTRING('20160701',1,8)
-- AND SUBSTRING(alias_0.fechadocumento,1,8)<= SUBSTRING('20170727',1,8)

-- AND (ALIAS_0.ESTADOTR = 'C' or ALIAS_0.ESTADOTR = 'A')
AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND  alias_1.codigo like 'VT03'

ORDER BY FECHA_DOCUMENTO desc