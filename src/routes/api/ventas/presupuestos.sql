SELECT 	item_venta.NOMBRETR TRANSACCION, 
				item_venta.ESTADOTR ESTADO, 
				flag.DESCRIPCION FLAG, 
				SUBSTRING(item_venta.FECHADOCUMENTO,1,4) ||'-'|| SUBSTRING(item_venta.FECHADOCUMENTO,5,2) ||'-'|| SUBSTRING(item_venta.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO, 
				SUBSTRING(item_venta.FECHAENTREGA,1,4) ||'-'|| SUBSTRING(item_venta.FECHAENTREGA,5,2) ||'-'|| SUBSTRING(item_venta.FECHAENTREGA,7,2) FECHA_ENTREGA, 
				item_venta.NUMERODOCUMENTO NUMERODOCUMENTO, 
				item_venta.NOMBREORIGINANTETR NOMBREORIGINANTETR, 
				item_venta.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR, 
				moneda.NOMBRE MONEDA, 
				tipo_transaccion.CODIGO CODIGO, 
				concepto_comercial.CODIGO CODIGOCC, 
				concepto_comercial.DESCRIPCION CONCEPTOCOMERCIAL, 
				tipo_transaccion.DESCRIPCION DESCRIPCION, 
				item_venta.CANTIDAD2_CANTIDAD CANTIDAD, 
				item_venta.CNOLINEAL2_CANTIDAD CANTIDAD_NL, 
				item_venta.VALOR2_IMPORTE PRECIO, 
				item_venta.IMPORTEBONIFICADO IMPORTE_BONIFICADO, 
				item_venta.TOTAL2_IMPORTE TOTAL_IMPORTE, 
				UNIDADES.NOMBRE unidad,
        tr_venta.valortotal total_transaccion,
        (tr_venta.valortotal - tr_venta.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem

FROM 			V_ITEMVENTA item_venta 

LEFT JOIN V_TIPOTRANSACCION tipo_transaccion ON item_venta.TIPOTRANSACCION_ID = tipo_transaccion.ID 
LEFT JOIN V_TRVENTA tr_venta ON item_venta.PLACEOWNER_ID = tr_venta.ID 
LEFT JOIN V_MONEDA moneda ON tr_venta.MONEDA_ID = moneda.ID 
LEFT JOIN V_FLAG flag ON tr_venta.FLAG_ID = flag.ID 
LEFT JOIN V_CONCEPTOCOMERCIAL concepto_comercial ON item_venta.REFERENCIA_ID = concepto_comercial.ID 
LEFT JOIN v_impuestotransaccion tImp ON tr_venta.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON item_venta.impuestositemtransaccion_id = tiImp.bo_place_id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON item_venta.UNIDADMEDIDA_ID = UNIDADES.ID 
	
WHERE item_venta.PLACEOWNER_ID IS NOT NULL 

AND SUBSTRING(item_venta.fechadocumento,1,8) >= SUBSTRING(${fechaDesde},1,8)
AND SUBSTRING(item_venta.fechadocumento,1,8)<= SUBSTRING(${fechaHasta},1,8)

-- AND SUBSTRING(item_venta.fechadocumento,1,8) >= SUBSTRING('20160701',1,8)
-- AND SUBSTRING(item_venta.fechadocumento,1,8)<= SUBSTRING('20170727',1,8)

AND item_venta.ESTADOTR = 'A'
AND item_venta.BO_PLACE_ID IS NOT NULL
AND  tipo_transaccion.codigo like 'VT03'

ORDER BY FECHA_DOCUMENTO desc