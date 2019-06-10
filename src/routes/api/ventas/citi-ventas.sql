SELECT 	
		SUBSTRING(TR_VENTA.FECHAACTUAL,1,4) ||''|| SUBSTRING(TR_VENTA.FECHAACTUAL,5,2) ||''|| SUBSTRING(TR_VENTA.FECHAACTUAL,7,2) FECHA_DOCUMENTO,
		SUBSTRING(TR_VENTA.NUMERODOCUMENTO,1,4) PUNTO_VENTA,
		SUBSTRING(TR_VENTA.NUMERODOCUMENTO,5,12) NRO_DOCUMENTO,
	    CASE 
			WHEN (clientes.cuit='XX' or clientes.cuit='xx') 
			THEN 
				CASE 
					WHEN (clientes.numerodocumento = '99999995')
					THEN '0'
					ELSE replace(clientes.numerodocumento, '.', '')
				END
            ELSE replace(clientes.cuit, '-', '')
		   END Documento,
		TR_VENTA.NOMBREDESTINATARIO NOMBRE_DESTINATARIOTRIO,
		tipo_transaccion.DESCRIPCION  TIPO_DOCUMENTO,
		TR_VENTA.nota POS_IVA,
		TR_VENTA.SUBTOTALIMPORTE NETO,
		TR_VENTA.valortotal total_transaccion,
		(TR_VENTA.valortotal - TR_VENTA.subtotalimporte -tImp.valorimporte) Iva,
		tImp.valorimporte IIBBtr

FROM V_TRVENTA TR_VENTA
LEFT JOIN V_TIPOTRANSACCION tipo_transaccion ON TR_VENTA.TIPOTRANSACCION_ID = tipo_transaccion.ID 
LEFT JOIN V_MONEDA moneda ON TR_VENTA.MONEDA_ID = moneda.ID
LEFT JOIN V_CLIENTE clientes ON TR_VENTA.destinatario_id = clientes.id
LEFT JOIN V_DOMICILIO domicilios ON TR_VENTA.domicilio_id = domicilios.id
LEFT JOIN V_CIUDAD ciudad ON domicilios.ciudad_id = ciudad.id
LEFT JOIN V_FLAG flag ON TR_VENTA.FLAG_ID = flag.ID 
LEFT JOIN v_impuestotransaccion tImp ON TR_VENTA.impuestostransaccion_id = tImp.bo_place_id

WHERE TR_VENTA.ESTADO = 'C'
AND SUBSTRING(TR_VENTA.FECHAACTUAL,1,8) >= SUBSTRING(${fechaDesde},1,8)
AND SUBSTRING(TR_VENTA.FECHAACTUAL,1,8) <= SUBSTRING(${fechaHasta},1,8)
-- AND SUBSTRING(TR_VENTA.FECHAACTUAL,1,8) >= SUBSTRING('20190501',1,8)
-- AND SUBSTRING(TR_VENTA.FECHAACTUAL,1,8) <= SUBSTRING('20190531',1,8)
AND (
		SUBSTRING(TR_VENTA.NUMERODOCUMENTO,1,4) != '0001' 
		or 
		SUBSTRING(TR_VENTA.NUMERODOCUMENTO,1,4) != '00011' 
	)
AND tipo_transaccion.codigo NOT LIKE 'VT01'  -- pedido a preparar
AND tipo_transaccion.codigo NOT LIKE 'VT02'  -- NP
AND tipo_transaccion.codigo NOT LIKE 'VT03' -- presupuesto
AND tipo_transaccion.codigo NOT LIKE 'VT10;RES-;' --Nota de credito de venta interna
AND tipo_transaccion.codigo NOT LIKE 'VT09;RES+;'  --Nota de Debito de Venta Interna
-- AND tipo_transaccion.codigo NOT LIKE 'VT06;VENTAS-;RES-;' --Factura Anulada

ORDER BY FECHA_DOCUMENTO, NRO_DOCUMENTO desc