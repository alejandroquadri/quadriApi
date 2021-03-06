SELECT 	item_venta.NOMBRETR TRANSACCION, 
		item_venta.ESTADOTR ESTADO, 
		flag.DESCRIPCION FLAG, 
		SUBSTRING(item_venta.FECHADOCUMENTO,1,4) ||'-'|| SUBSTRING(item_venta.FECHADOCUMENTO,5,2) ||'-'|| SUBSTRING(item_venta.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO, 
		SUBSTRING(item_venta.FECHAENTREGA,1,4) ||'-'|| SUBSTRING(item_venta.FECHAENTREGA,5,2) ||'-'|| SUBSTRING(item_venta.FECHAENTREGA,7,2) FECHA_ENTREGA, 
		item_venta.NUMERODOCUMENTO NUMERODOCUMENTO, 
		item_venta.NOMBREORIGINANTETR NOMBREORIGINANTETR, 
		item_venta.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR,
		clientes.cuit cuit,
		clientes.numerodocumento dni,
		domicilios.calle calle,
		ciudad.nombre ciudad,
		domicilios.nombredomicilio domicilio,
		tr_venta.detalle detalle,
		moneda.NOMBRE MONEDA, 
		tipo_transaccion.CODIGO CODIGO, 
		concepto_comercial.CODIGO CODIGOCC, 
		concepto_comercial.DESCRIPCION CONCEPTOCOMERCIAL, 
		tipo_transaccion.DESCRIPCION  TIPO_DOCUMENTO,
		tr_venta.nota POS_IVA,
		tipo_transaccion.DESCRIPCION ||' '|| tr_venta.nota TIPO_DOCUMENTO_FULL,
		item_venta.CANTIDAD2_CANTIDAD CANTIDAD, 
		item_venta.CNOLINEAL2_CANTIDAD CANTIDAD_NL, 
		item_venta.VALOR2_IMPORTE PRECIO,
		(1 - (item_venta.TOTAL2_IMPORTE / item_venta.CANTIDAD2_CANTIDAD)/item_venta.VALOR2_IMPORTE) DESCUENTO,
		( item_venta.TOTAL2_IMPORTE / item_venta.CANTIDAD2_CANTIDAD ) PRECIO_DESCUENTO,
		item_venta.IMPORTEBONIFICADO IMPORTE_BONIFICADO, 
		item_venta.TOTAL2_IMPORTE TOTAL_IMPORTE, 
		UNIDADES.NOMBRE unidad,
        tr_venta.valortotal total_transaccion,
        (tr_venta.valortotal - tr_venta.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem,
		V_POSICIONIMPUESTO.NOMBRE AS COND_IVA

FROM 	V_ITEMVENTA item_venta 

LEFT JOIN V_TIPOTRANSACCION tipo_transaccion ON item_venta.TIPOTRANSACCION_ID = tipo_transaccion.ID 
LEFT JOIN V_TRVENTA tr_venta ON item_venta.PLACEOWNER_ID = tr_venta.ID 
LEFT JOIN V_MONEDA moneda ON tr_venta.MONEDA_ID = moneda.ID
LEFT JOIN V_CLIENTE clientes ON tr_venta.destinatario_id = clientes.id
LEFT JOIN V_DOMICILIO domicilios ON tr_venta.domicilio_id = domicilios.id
LEFT JOIN V_CIUDAD ciudad ON domicilios.ciudad_id = ciudad.id
LEFT JOIN V_FLAG flag ON tr_venta.FLAG_ID = flag.ID 
LEFT JOIN V_CONCEPTOCOMERCIAL concepto_comercial ON item_venta.REFERENCIA_ID = concepto_comercial.ID 
LEFT JOIN v_impuestotransaccion tImp ON tr_venta.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON item_venta.impuestositemtransaccion_id = tiImp.bo_place_id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON item_venta.UNIDADMEDIDA_ID = UNIDADES.ID 
LEFT JOIN V_POSICIONADORIMPUESTOS ON clientes.POSICIONADORIMPUESTOS_ID = V_POSICIONADORIMPUESTOS.ID
LEFT JOIN V_ITEMPOSICIONADORIMPUESTOS ON V_POSICIONADORIMPUESTOS.ITEMSPOSICIONADORIMPUESTOS_ID = V_ITEMPOSICIONADORIMPUESTOS.BO_PLACE_ID
LEFT JOIN V_POSICIONIMPUESTO ON V_ITEMPOSICIONADORIMPUESTOS.POSICIONIMPUESTO_ID = V_POSICIONIMPUESTO.ID
LEFT JOIN V_DEFINICIONIMPUESTO ON V_ITEMPOSICIONADORIMPUESTOS.DEFINICIONIMPUESTO_ID = V_DEFINICIONIMPUESTO.ID
LEFT JOIN V_IMPUESTO ON V_DEFINICIONIMPUESTO.IMPUESTO_ID = V_IMPUESTO.ID
	
WHERE item_venta.PLACEOWNER_ID IS NOT NULL 

AND SUBSTRING(item_venta.fechadocumento,1,8) >= SUBSTRING('20190101',1,8)
AND (
		SUBSTRING(item_venta.NUMERODOCUMENTO,1,4) = '0001' 
		or 
		SUBSTRING(item_venta.NUMERODOCUMENTO,1,4) = '00011' 
	)
AND item_venta.ESTADOTR = 'C'
AND item_venta.BO_PLACE_ID IS NOT NULL
AND item_venta.VALOR2_IMPORTE <> '0' -- para que no traiga precios en 0
AND tipo_transaccion.codigo NOT LIKE 'VT01'  -- pedido a preparar
AND tipo_transaccion.codigo NOT LIKE 'VT02'  -- NP
AND tipo_transaccion.codigo NOT LIKE 'VT03' -- presupuesto
AND tipo_transaccion.codigo NOT LIKE 'VT10;RES-;' --Nota de credito de venta interna
AND tipo_transaccion.codigo NOT LIKE 'VT09;RES+;'  --Nota de Debito de Venta Interna
-- AND tipo_transaccion.codigo NOT LIKE 'VT06;VENTAS-;RES-;' --Factura Anulada
AND V_IMPUESTO.NOMBRE = 'IVA TASA'

ORDER BY FECHA_DOCUMENTO desc


-- SELECT 	item_venta.NOMBRETR TRANSACCION, 
-- 		item_venta.ESTADOTR ESTADO, 
-- 		flag.DESCRIPCION FLAG, 
-- 		SUBSTRING(item_venta.FECHADOCUMENTO,1,4) ||'-'|| SUBSTRING(item_venta.FECHADOCUMENTO,5,2) ||'-'|| SUBSTRING(item_venta.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO, 
-- 		SUBSTRING(item_venta.FECHAENTREGA,1,4) ||'-'|| SUBSTRING(item_venta.FECHAENTREGA,5,2) ||'-'|| SUBSTRING(item_venta.FECHAENTREGA,7,2) FECHA_ENTREGA, 
-- 		item_venta.NUMERODOCUMENTO NUMERODOCUMENTO, 
-- 		item_venta.NOMBREORIGINANTETR NOMBREORIGINANTETR, 
-- 		item_venta.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR,
-- 		clientes.cuit cuit,
-- 		clientes.numerodocumento dni,
-- 		domicilios.calle calle,
-- 		ciudad.nombre ciudad,
-- 		domicilios.nombredomicilio domicilio,
-- 		tr_venta.detalle detalle,
-- 		moneda.NOMBRE MONEDA, 
-- 		tipo_transaccion.CODIGO CODIGO, 
-- 		concepto_comercial.CODIGO CODIGOCC, 
-- 		concepto_comercial.DESCRIPCION CONCEPTOCOMERCIAL, 
-- 		tipo_transaccion.DESCRIPCION  TIPO_DOCUMENTO,
-- 		tr_venta.nota POS_IVA,
-- 		tipo_transaccion.DESCRIPCION ||' '|| tr_venta.nota TIPO_DOCUMENTO_FULL,
-- 		item_venta.CANTIDAD2_CANTIDAD CANTIDAD, 
-- 		item_venta.CNOLINEAL2_CANTIDAD CANTIDAD_NL, 
-- 		item_venta.VALOR2_IMPORTE PRECIO,
-- 		(1 - (item_venta.TOTAL2_IMPORTE / item_venta.CANTIDAD2_CANTIDAD)/item_venta.VALOR2_IMPORTE) DESCUENTO,
-- 		( item_venta.TOTAL2_IMPORTE / item_venta.CANTIDAD2_CANTIDAD ) PRECIO_DESCUENTO,
-- 		item_venta.IMPORTEBONIFICADO IMPORTE_BONIFICADO, 
-- 		item_venta.TOTAL2_IMPORTE TOTAL_IMPORTE, 
-- 		UNIDADES.NOMBRE unidad,
--         tr_venta.valortotal total_transaccion,
--         (tr_venta.valortotal - tr_venta.subtotalimporte -tImp.valorimporte) Iva,
--         tImp.valorimporte IIBBtr,
-- 		tiImp.valorimporte IVAitem,
-- 		V_POSICIONIMPUESTO.NOMBRE AS COND_IVA


-- FROM 	V_ITEMVENTA item_venta 

-- LEFT JOIN V_TIPOTRANSACCION tipo_transaccion ON item_venta.TIPOTRANSACCION_ID = tipo_transaccion.ID 
-- LEFT JOIN V_TRVENTA tr_venta ON item_venta.PLACEOWNER_ID = tr_venta.ID 
-- LEFT JOIN V_MONEDA moneda ON tr_venta.MONEDA_ID = moneda.ID
-- LEFT JOIN V_CLIENTE clientes ON tr_venta.destinatario_id = clientes.id
-- LEFT JOIN V_DOMICILIO domicilios ON tr_venta.domicilio_id = domicilios.id
-- LEFT JOIN V_CIUDAD ciudad ON domicilios.ciudad_id = ciudad.id
-- LEFT JOIN V_FLAG flag ON tr_venta.FLAG_ID = flag.ID 
-- LEFT JOIN V_CONCEPTOCOMERCIAL concepto_comercial ON item_venta.REFERENCIA_ID = concepto_comercial.ID 
-- LEFT JOIN v_impuestotransaccion tImp ON tr_venta.impuestostransaccion_id = tImp.bo_place_id
-- LEFT JOIN v_impuestotransaccion tiImp ON item_venta.impuestositemtransaccion_id = tiImp.bo_place_id
-- LEFT JOIN V_UNIDADMEDIDA UNIDADES ON item_venta.UNIDADMEDIDA_ID = UNIDADES.ID
-- LEFT JOIN V_POSICIONADORIMPUESTOS ON clientes.POSICIONADORIMPUESTOS_ID = V_POSICIONADORIMPUESTOS.ID
-- LEFT JOIN V_ITEMPOSICIONADORIMPUESTOS ON V_POSICIONADORIMPUESTOS.ITEMSPOSICIONADORIMPUESTOS_ID = V_ITEMPOSICIONADORIMPUESTOS.BO_PLACE_ID
-- LEFT JOIN V_POSICIONIMPUESTO posImpuesto ON V_ITEMPOSICIONADORIMPUESTOS.POSICIONIMPUESTO_ID = V_POSICIONIMPUESTO.ID
	
-- WHERE item_venta.PLACEOWNER_ID IS NOT NULL 

-- AND SUBSTRING(item_venta.fechadocumento,1,8) >= SUBSTRING('20190101',1,8)
-- AND (
-- 		SUBSTRING(item_venta.NUMERODOCUMENTO,1,4) = '0001' 
-- 		or 
-- 		SUBSTRING(item_venta.NUMERODOCUMENTO,1,4) = '00011' 
-- 	)
-- AND item_venta.ESTADOTR = 'C'
-- AND item_venta.BO_PLACE_ID IS NOT NULL
-- AND item_venta.VALOR2_IMPORTE <> '0' -- para que no traiga precios en 0
-- AND tipo_transaccion.codigo NOT LIKE 'VT01'  -- pedido a preparar
-- AND tipo_transaccion.codigo NOT LIKE 'VT02'  -- NP
-- AND tipo_transaccion.codigo NOT LIKE 'VT03' -- presupuesto
-- AND tipo_transaccion.codigo NOT LIKE 'VT10;RES-;' --Nota de credito de venta interna
-- AND tipo_transaccion.codigo NOT LIKE 'VT09;RES+;'  --Nota de Debito de Venta Interna
-- -- AND tipo_transaccion.codigo NOT LIKE 'VT06;VENTAS-;RES-;' --Factura Anulada

-- ORDER BY FECHA_DOCUMENTO desc