SELECT  ALIAS_0.NOMBRETR TRANSACCION,
        ALIAS_0.ESTADOTR ESTADO,
        ALIAS_7.DESCRIPCION FLAG,
        SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'||SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
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
        gv.descripcion AS origen,
        seg.nombre5 AS MARCA,
        UNIDADES.NOMBRE unidad,
        '' AS tipo_pago,
        ALIAS_5.valortotal total_transaccion,
        (ALIAS_5.valortotal - ALIAS_5.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem

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
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_producto
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_servicio
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_conceptocontable
          ) b on ALIAS_0.referencia_id = b.id
LEFT JOIN segmento seg on b.segmento_id = seg.id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON ALIAS_0.UNIDADMEDIDA_ID = UNIDADES.ID 
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

LEFT JOIN grupovistas GV ON GV.id = UD.origenFV_id
LEFT JOIN v_impuestotransaccion tImp ON ALIAS_5.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON ALIAS_0.impuestositemtransaccion_id = tiImp.bo_place_id

WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

AND substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
AND substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)


-- AND substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
-- AND substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)

AND (ALIAS_0.ESTADOTR = 'C')
AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND alias_1.codigo NOT LIKE 'VT05;RES-;tt-'
AND alias_1.codigo NOT LIKE 'VT02'
AND alias_1.codigo NOT LIKE 'VT01'
AND alias_1.codigo NOT LIKE 'VT10;RES-;'
AND alias_1.codigo NOT LIKE 'VT09;RES+;'
AND alias_1.codigo NOT LIKE 'VT06;VENTAS-;RES-;'
AND alias_1.codigo NOT LIKE 'VT14'
AND alias_1.codigo NOT LIKE 'VT03'

--notas de credito y comprobantes que restan a las facturas
UNION ALL

SELECT  ALIAS_0.NOMBRETR TRANSACCION,
        ALIAS_0.ESTADOTR ESTADO,
        ALIAS_7.DESCRIPCION FLAG,
        SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'||SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
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
        seg.nombre5 as MARCA,
        UNIDADES.NOMBRE unidad,
        '' AS tipo_pago,
        ALIAS_5.valortotal total_transaccion,
        (ALIAS_5.valortotal - ALIAS_5.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem

FROM      V_ITEMVENTA ALIAS_0
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
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_producto
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_servicio
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_conceptocontable
          ) b on ALIAS_0.referencia_id = b.id
LEFT JOIN segmento seg on b.segmento_id = seg.id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON ALIAS_0.UNIDADMEDIDA_ID = UNIDADES.ID
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
LEFT JOIN v_impuestotransaccion tImp ON ALIAS_5.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON ALIAS_0.impuestositemtransaccion_id = tiImp.bo_place_id

WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

AND substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
AND substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)

-- AND substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
-- AND substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)

AND (ALIAS_0.ESTADOTR = 'C')
AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND alias_1.codigo NOT LIKE 'VT13;VENTAS+;RES+;'
AND alias_1.codigo NOT LIKE 'VT03;VENTAS+;RES+;'
AND alias_1.codigo NOT LIKE 'VT11;VENTAS+;RES+;'
AND alias_1.codigo NOT LIKE 'VT04;RES+;'
AND alias_1.codigo NOT LIKE 'VT02'
AND alias_1.codigo NOT LIKE 'VT01'
AND alias_1.codigo NOT LIKE 'VT10;RES-;'
AND alias_1.codigo NOT LIKE 'VT09;RES+;'
AND alias_1.codigo NOT LIKE 'VT14'
AND alias_1.codigo NOT LIKE 'VT03'

--Presupuestos solo los que estan activos y pendientes

UNION ALL

SELECT  ALIAS_0.NOMBRETR TRANSACCION,
        ALIAS_0.ESTADOTR ESTADO,
        ALIAS_7.DESCRIPCION FLAG,
        SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'||SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
        SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) FECHA_ENTREGA,
        ALIAS_0.NUMERODOCUMENTO NUMERODOCUMENTO,
        ALIAS_0.NOMBREORIGINANTETR NOMBREORIGINANTETR,
        ALIAS_0.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR,
        ALIAS_6.NOMBRE MONEDA,
        ALIAS_0.COTIZACION COTIZACION,
        ALIAS_1.CODIGO CODIGO,
        ALIAS_9.CODIGO CODIGOCC,
        ALIAS_0.DESCRIPCION CONCEPTOCOMERCIAL,
        ALIAS_1.DESCRIPCION DESCRIPCION,
        ALIAS_1.AFECTASTOCK AFECTASTOCK,
        ALIAS_0.CANTIDAD2_CANTIDAD CANTIDAD,
        ALIAS_0.CNOLINEAL2_CANTIDAD CANTIDAD_NL,
        ALIAS_0.VALOR2_IMPORTE PRECIO,
        ALIAS_0.IMPORTEBONIFICADO IMPORTE_BONIFICADO,
        ALIAS_0.TOTAL2_IMPORTE TOTAL_IMPORTE,
        gv.descripcion as origen,
        seg.nombre5 as MARCA,
        UNIDADES.NOMBRE unidad,
        tipopago.observacion AS tipo_pago,
        ALIAS_5.valortotal total_transaccion,
        (ALIAS_5.valortotal - ALIAS_5.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem

FROM      V_ITEMVENTA ALIAS_0
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
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_producto
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_servicio
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_conceptocontable
          ) b on ALIAS_0.referencia_id = b.id
LEFT JOIN segmento seg on b.segmento_id = seg.id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON ALIAS_0.UNIDADMEDIDA_ID = UNIDADES.ID
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
LEFT JOIN v_impuestotransaccion tImp ON ALIAS_5.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON ALIAS_0.impuestositemtransaccion_id = tiImp.bo_place_id
LEFT JOIN v_trpresupuestoventa tr_psp on ALIAS_0.PLACEOWNER_ID = tr_psp.id
LEFT JOIN v_tipopago tipopago on tr_psp.tipopago_id = tipopago.id

WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

AND substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
AND substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)

--  AND substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
--  AND substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)

AND (ALIAS_0.ESTADOTR = 'A' or ALIAS_0.ESTADOTR = 'C')
AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND alias_1.codigo NOT LIKE 'VT05;RES-;tt-' --Nota de Credito--
AND alias_1.codigo NOT LIKE 'VT02'  --Nota de Venta--
AND alias_1.codigo NOT LIKE 'VT01'
AND alias_1.codigo NOT LIKE 'VT10;RES-;' --Nota de credito de venta interna--
AND alias_1.codigo NOT LIKE 'VT09;RES+;'  --Nota de Debito de Venta Interna--
AND alias_1.codigo NOT LIKE 'VT06;VENTAS-;RES-;' --Factura Anulada--
AND alias_1.codigo NOT LIKE 'VT14'
--AND alias_1.codigo NOT LIKE 'VT03' --Preupuesto--
AND ALIAS_7.DESCRIPCION NOT LIKE 'Anulada'
AND ALIAS_7.DESCRIPCION NOT LIKE 'Licitacion'
AND alias_1.codigo NOT LIKE 'VT13;VENTAS+;RES+;'
AND alias_1.codigo NOT LIKE 'VT11;VENTAS+;RES+;'
AND alias_1.codigo NOT LIKE 'VT04;RES+;'
AND alias_1.codigo NOT LIKE 'VT03;VENTAS+;RES+;'


--ORDER BY alias_1.codigo, flag desc

--Notas de pedido Trae solo notas de pedido pendientes de entrega, no toma en cuenta NP saldadas.

UNION ALL

SELECT  ALIAS_0.NOMBRETR TRANSACCION,
        ALIAS_0.ESTADOTR ESTADO,
        ALIAS_7.DESCRIPCION FLAG,
        SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'||SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
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
        seg.nombre5 as MARCA,
        UNIDADES.NOMBRE unidad,
        '' AS tipo_pago,
        ALIAS_5.valortotal total_transaccion,
        (ALIAS_5.valortotal - ALIAS_5.subtotalimporte -tImp.valorimporte) Iva,
        tImp.valorimporte IIBBtr,
        tiImp.valorimporte IVAitem

/*,
        Case when p.saldada = 'F' then 'Pendiente'
        else 'entregado'
        end as prueba
          */

FROM      V_ITEMVENTA ALIAS_0
LEFT JOIN pendiente p on alias_0.placeowner_id = p.transaccion_id
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
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_producto
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_servicio
            UNION
            SELECT  id, segmento_id, codigo, rubro_id, activestatus
            FROM    v_conceptocontable
          ) b on ALIAS_0.referencia_id = b.id
LEFT JOIN segmento seg on b.segmento_id = seg.id
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON ALIAS_0.UNIDADMEDIDA_ID = UNIDADES.ID
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
LEFT JOIN v_impuestotransaccion tImp ON ALIAS_5.impuestostransaccion_id = tImp.bo_place_id
LEFT JOIN v_impuestotransaccion tiImp ON ALIAS_0.impuestositemtransaccion_id = tiImp.bo_place_id

WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

AND substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
AND substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)

--  AND substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
--  AND substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)

AND (ALIAS_0.ESTADOTR = 'C')
AND ALIAS_0.BO_PLACE_ID IS NOT NULL
AND (p.saldada = 'F')
AND TIPOTRGENERAR_ID ='89C23593-3F01-11D5-86AD-0080AD403F5F'
AND alias_1.codigo NOT LIKE 'VT05;RES-;tt-' --Nota de Credito--
--AND alias_1.codigo NOT LIKE 'VT02'  --Nota de Venta--
AND alias_1.codigo NOT LIKE 'VT01'
AND alias_1.codigo NOT LIKE 'VT10;RES-;' --Nota de credito de venta interna--
AND alias_1.codigo NOT LIKE 'VT09;RES+;'  --Nota de Debito de Venta Interna--
AND alias_1.codigo NOT LIKE 'VT06;VENTAS-;RES-;' --Factura Anulada--
AND alias_1.codigo NOT LIKE 'VT14'
AND alias_1.codigo NOT LIKE 'VT03' --Preupuesto--
AND ALIAS_7.DESCRIPCION NOT LIKE 'Anulada'
AND ALIAS_7.DESCRIPCION NOT LIKE 'Licitacion'
AND alias_1.codigo NOT LIKE 'VT13;VENTAS+;RES+;'
AND alias_1.codigo NOT LIKE 'VT11;VENTAS+;RES+;'
AND alias_1.codigo NOT LIKE 'VT04;RES+;'
AND alias_1.codigo NOT LIKE 'VT03;VENTAS+;RES+;'

GROUP BY  codigocc,
          ALIAS_0.NOMBRETR,
          ALIAS_0.ESTADOTR,
          ALIAS_7.DESCRIPCION,
          ALIAS_0.FECHADOCUMENTO,
          ALIAS_0.FECHAENTREGA,
          ALIAS_0.NUMERODOCUMENTO ,
          ALIAS_0.NOMBREORIGINANTETR ,
          ALIAS_0.NOMBREDESTINATARIOTR ,
          ALIAS_6.NOMBRE ,
          ALIAS_0.COTIZACION ,
          ALIAS_1.CODIGO ,
          ALIAS_9.DESCRIPCION ,
          ALIAS_1.DESCRIPCION ,
          ALIAS_1.AFECTASTOCK ,
          ALIAS_0.CANTIDAD2_CANTIDAD ,
          ALIAS_0.CNOLINEAL2_CANTIDAD ,
          ALIAS_0.VALOR2_IMPORTE ,
          ALIAS_0.IMPORTEBONIFICADO ,
          ALIAS_0.TOTAL2_IMPORTE ,
          gv.descripcion,
          seg.nombre5,
          UNIDADES.NOMBRE,
          total_transaccion,
          Iva,
          IVAitem,
          IIBBtr
          

ORDER BY transaccion
